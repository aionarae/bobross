class CanvasAccount < Forgery
  attr_reader :name, :uid, :parent_uid, :root_uid, :time_zone, :sis_id, :workflow

  def to_s
    string = "#{name}, #{uid}, #{parent_uid}, #{root_uid}, #{time_zone}, #{sis_id}, #{workflow}"
  end

  def to_csv
    row = [name, uid, parent_uid, root_uid, time_zone, sis_id, workflow]
  end
#future relase: Make fields reuired by canvas required here
  def initialize(opts = {})
    @name = opts[:name] if opts[:name]
    @uid = opts[:uid] if opts[:uid]
    @parent_id = opts[:parent] if opts[:parent]
    @root_id = opts[:root] if opts[:root]
    @time_zone = opts[:time_zone] if opts[:time_zone]
    @sis_id = opts[:sis] if opts[:sis]
    @workflow = opts[:workflow] if opts[:workflow]
  end

  def self.random (parent_id = 1 , root_id = 1)
    a = Forgery('name').company_name
    CanvasAccount.new(
      {
        name: a,
        uid: "#{a}-#{rand(10000)}",
        parent: parent_id,
        root: root_id,
        time_zone: Forgery('time').zone,
        sis_id: (10000+rand(10000000)),
        workflow: 'active'
        }
      )
  end

  def self.gen_file(opts = {})
    parent, root = 1
    rows = 0
    parent = opts[:parent] if opts[:parent]
    root = opts[:root] if opts[:root]
    rows = opts[:rows] if opts[:rows]
    accounts = []
    if(opts[:rows])
      rows.times do |x|
        accounts.push(CanvasAccount.random(parent, root))
      end
    end
    header = ["name", "uid", "parent_id", "root_id", "time_zone", "sis_id", "workflow"]
    CSV.open("./accounts.csv", "wb", write_headers: true, headers: header) do |csv|
      accounts.each do |acc|
        csv << acc.to_csv
      end
    end
  end
end
