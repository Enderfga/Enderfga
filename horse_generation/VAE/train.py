from torch import optim
from torch.autograd import Variable
from tqdm import tqdm
import utils



def train_model(model, dataset, epochs=10,
                batch_size=32, sample_size=32,
                lr=3e-04, weight_decay=1e-5,
                loss_log_interval=30,
                image_log_interval=300,
                checkpoint_dir='./checkpoints',
                resume=False,
                cuda=False):
    # prepare optimizer and model
    model.train()
    optimizer = optim.Adam(
        model.parameters(), lr=lr,
        weight_decay=weight_decay,
    )

    if resume:
        epoch_start = utils.load_checkpoint(model, checkpoint_dir)
    else:
        epoch_start = 1

    for epoch in range(epoch_start, epochs+1):
        data_loader = utils.get_data_loader(dataset, batch_size, cuda=cuda)
        data_stream = tqdm(enumerate(data_loader, 1))

        for batch_index, (x, _) in data_stream:
            # where are we?
            iteration = (epoch-1)*(len(dataset)//batch_size) + batch_index

            # prepare data on gpu if needed
            x = Variable(x).cuda() if cuda else Variable(x)

            # flush gradients and run the model forward
            optimizer.zero_grad()
            (mean, logvar), x_reconstructed = model(x)
            reconstruction_loss = model.reconstruction_loss(x_reconstructed, x)
            kl_divergence_loss = model.kl_divergence_loss(mean, logvar)
            total_loss = reconstruction_loss + kl_divergence_loss

            # backprop gradients from the loss
            total_loss.backward()
            optimizer.step()

            # update progress
            data_stream.set_description((
                'epoch: {epoch} | '
                'iteration: {iteration} | '
                'progress: [{trained}/{total}] ({progress:.0f}%) | '
                'loss => '
                'total: {total_loss:.4f} / '
                're: {reconstruction_loss:.3f} / '
                'kl: {kl_divergence_loss:.3f}'
            ).format(
                epoch=epoch,
                iteration=iteration,
                trained=batch_index * len(x),
                total=len(data_loader.dataset),
                progress=(100. * batch_index / len(data_loader)),
                total_loss=total_loss.item(),
                reconstruction_loss=reconstruction_loss.item(),
                kl_divergence_loss=kl_divergence_loss.item(),
            ))

            

        # notify that we've reached to a new checkpoint.
        print()
        print()
        print('#############')
        print('# checkpoint!')
        print('#############')
        print()

        # save the checkpoint.
        utils.save_checkpoint(model, checkpoint_dir, epoch)
        print()
