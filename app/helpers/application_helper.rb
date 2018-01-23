
module ApplicationHelper
  extend Memoist

  memoize def current_glob
    $LIBRARY.glob(params[:path])
  end

  memoize def sorted_current_glob
    NatSortArray.new(current_glob).sort_by_natcmp($SITE_SETTINGS.site.sort_options) { |item|
      File.basename(item)
    }
  end

  memoize def current_path
    public_path(params[:path])
  end

  memoize def public_path(path)
    public_path = path.to_s.sub(%r{^#{$LIBRARY.settings.path}/}, '')
    public_path = "/#{public_path}" unless public_path[0] == '/'
    public_path
  end

  memoize def public_name(path)
    File.basename(path)
  end

  memoize def public_link_to(path)
    link_to(public_name(path), public_path(path))
  end

  memoize def page_title
    title = [ $SITE_SETTINGS.site.title ]
    path = current_path

    title << path if path.present?

    title.join(' - ')
  end

  memoize def path_contains_files?
    !!current_glob.detect(&:file?)
  end

  memoize def path_is_root?
    params[:path].blank? || params[:path] == '/'
  end

  memoize def link_to_void(*args)
    link_to(args.shift, 'javascript:void(0)', *args)
  end

  memoize def link_to_up(*args)
    up = "/#{File.dirname(params[:path])}" unless path_is_root?

    link_to('↟ Up', up, *args)
  end
end
