# module Jekyll
#
#   class CategoryPage < Page
#     def initialize(site, base, dir, category)
#       @site = site
#       @base = base
#       @dir = dir
#       @name = 'index.html'
#
#       self.process(@name)
#       self.read_yaml(File.join(base, '_layouts'), 'archive.html')
# #       page.data['layout'] = 'your_layout'
# #       self.data['category'] = Array(category).pop
#       category_title_prefix = site.config['category_title_prefix'] || 'Category: '
#       self.data['title'] = "#{category_title_prefix}#{category}"
#     end
#   end
# #
#   class CategoryPageGenerator < Generator
#     safe true
#     def generate(site)
#       all_categories = Set.new
#       category_tree = {'title' => 'Categories Tree', 'layout' => 'category', 'children' => {}}
#       site.posts.each do |page|
#         categories = Array(page.data['category'])
#         parent = category_tree['children']
#
#         categories.each do |category|
#           parent[category] ||= {'title' => category, 'layout' => 'category', 'children' => {}, 'self' => {}}
#           parent = parent[category]['children']
#         end
#
#         parent[page.title] ||= {'title' => page.title, 'layout' => page.layout, 'children' => {}, 'self'=> page}
#         parent = parent[page.title]['children']
#
#       end
#
#       print category_tree
#       base_path = '/categories/'
#       generate_pages(category_tree, base_path, site)
# #       category_tree['children'].each do |category, sub_node|
# #         category_path = File.join(base_path, category)
# # #         print category
# #         generate_pages(sub_node, category_path, site)
# #       end
#     end
#
#
#   def generate_pages(node, parent_path, site)
#         node['children'].each do |category, layout, sub_node|
#
#         print category
# #         if layout == 'post'
# #             filename = category['title'].to_s# "#{category}"
# #         elif layout == 'category'
# #             filename = category
# #         end
#         filename = category
#         print filename
#         category_path = File.join(parent_path, filename)
#         # 创建页面
#         page = CategoryPage.new(site, site.source, category_path, filename)
#
# #         print category_path
# #         page.data['layout'] = 'your_layout'
# #         page.data['category'] = sub_node['name']
# #         page.content = sub_node['content']
# #
# #         # 将子目录和该节点的内容添加到页面
# #         page.data['children'] = sub_node['children'].keys
# #         page.data['parent_content'] = node['content']
#
#         # 将页面添加到站点
#         site.pages << page
#         if sub_node
#         generate_pages(sub_node, category_path, site)
#         end
#       end
#     end
#   end
# end
