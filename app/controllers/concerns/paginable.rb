module Paginable
  extend ActiveSupport::Concern
  
  def paginator
    JSOM::Pagination::Paginator.new
  end
  
  def pagination_params
    params.permit![:page] # defaults to 20 pages 
  end
  
  def paginate(collection)
    paginator.call(collection, params: pagination_params, base_url: request.url)
  end

  def render_collection(paginated)
    options = {
      meta: paginated.meta.to_h.merge(pagination_params), # Will get total pages, total count, etc.
      # links: paginated.links.to_h
      params: { admin: current_user.admin?, current_user: current_user }

    }
    paginated_result = serializer.new(paginated.items, options)

    render json: paginated_result
  end
end