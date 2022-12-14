# Install tmux
package 'tmux' do
  user 'root' unless node[:platform] == "darwin"
  action :install
end

link "#{ENV['HOME']}/.tmux.conf" do
  to "#{ENV['HOME']}/.dotfiles/conf/tmux.conf"
end

directory "#{ENV['HOME']}/.tmux.conf.d"
%w[
  reattach-to-user-namespace.conf
].each do |file|
  link "#{ENV['HOME']}/.tmux.conf.d/#{file}" do
    to "#{ENV['HOME']}/.dotfiles/conf/tmux.conf.d/#{file}"
  end
end

# Install tpm
directory "#{ENV['HOME']}/.tmux/plugins"

git "#{ENV['HOME']}/.tmux/plugins/tpm" do
  repository "https://github.com/tmux-plugins/tpm.git"
end
