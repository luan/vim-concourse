# Vim Concourse

Syntax detection and highlighting for [concourse](http://concourse.ci) pipelines.

## Features

* Custom highlighting aware of concourse terminology
* Folding
* Auto detecting concourse files
* [Tagbar](https://raw.githubusercontent.com/luan/flytags/master/screenshots/screenshot-01.png) integration
* Automatic [ctags](http://ctags.sourceforge.net/) generation for use with `<c-]>` on jobs and resources

## Settings

By default vim-concourse will generate ctags for your concourse pipelines using [flytags](http://github.com/luan/flytags) on save.
You can disable this functionality with:
```vim
let g:concourse_tags_autosave = 0
```

## In Action

![vim-concourse video](https://raw.githubusercontent.com/luan/vim-concourse/master/screenshots/video-01.gif)

## Credits

* [vim-go](https://github.com/fatih/vim-go), where form a lot of the plugin code was based
* [concourse](http://concourse.ci), the concourse ci system

## License

The BSD 3-Clause License - see [LICENSE](LICENSE) for more details.

Uses the vim-go LICENSE and copyrights since a lot of the code was re-used.

