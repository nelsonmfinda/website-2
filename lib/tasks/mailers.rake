namespace :mailers do
  task :deliver_side_exercise_changes => :environment do
    users = User.distinct.where(id:
      Iteration.where("iterations.created_at > ?", Exercism::V2_MIGRATED_AT).
      joins("INNER JOIN solutions on solutions.id = iterations.solution_id").
      distinct.
      select(:user_id)
    ).
    joins(:communication_preferences).
    where('communication_preferences.receive_product_updates': true).
    order('id asc')

    users.each do |user|
      begin
        NewsletterMailer.with(user: user).side_exercise_changes.deliver
        p "+ #{user.id}"
      rescue
        p "- #{user.id}"
      end
    end
  end
end
