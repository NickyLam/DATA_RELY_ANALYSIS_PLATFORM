/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cpms_t_account_point
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.cpms_t_account_point_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.cpms_t_account_point;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cpms_t_account_point_op purge;
drop table ${iol_schema}.cpms_t_account_point_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cpms_t_account_point_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cpms_t_account_point where 0=1;

create table ${iol_schema}.cpms_t_account_point_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cpms_t_account_point where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.cpms_t_account_point_cl(
            id -- 
            ,branch_no -- 
            ,card_no -- 
            ,customer_no -- 
            ,id_card -- 
            ,custom_type -- 
            ,card_type -- 
            ,card_product -- 
            ,cur_valid_point -- 
            ,his_valid_point -- 
            ,total_valid_point -- 当前可用积分+历史可用积分
            ,used_point -- 从开卡开始，兑换减少积分+转移转出积分
            ,cut_point_used -- 
            ,total_point -- 从开卡开始，消费增加积分+调整增加积分-调整减少积分+转移转入积分
            ,due_point -- 已经做了结转，但是还没做打折的积分
            ,year_used_point -- 从当年的1月1日开始，兑换减少积分+转移转出积分
            ,discount_date -- 指打折日期
            ,last_dis_date -- 
            ,last_init_date -- 
            ,drop_card_date -- 
            ,remark -- 
            ,issue_branch -- 
            ,last_his_valid_point -- 
            ,last_ope_time -- 
            ,last_dis_time -- 
            ,last_init_time -- 
            ,customer_name -- 
            ,point_type -- 01-标准积分； 02-个人存款积分； 03-个人贷款积分 ； 04-个人理财积分； 05-红利； 06-里程；
            ,state -- 01-正常； 02-冻结；
            ,operator_id -- 
            ,author_id -- 
            ,operate_date -- 
            ,operate_time -- 
            ,expand_1 -- 
            ,expand_2 -- 
            ,expand_3 -- 
            ,expand_4 -- 
            ,expand_5 -- 
            ,is_valid -- 0-有效 1-失效
            ,author_name -- 
            ,author_real_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.cpms_t_account_point_op(
            id -- 
            ,branch_no -- 
            ,card_no -- 
            ,customer_no -- 
            ,id_card -- 
            ,custom_type -- 
            ,card_type -- 
            ,card_product -- 
            ,cur_valid_point -- 
            ,his_valid_point -- 
            ,total_valid_point -- 当前可用积分+历史可用积分
            ,used_point -- 从开卡开始，兑换减少积分+转移转出积分
            ,cut_point_used -- 
            ,total_point -- 从开卡开始，消费增加积分+调整增加积分-调整减少积分+转移转入积分
            ,due_point -- 已经做了结转，但是还没做打折的积分
            ,year_used_point -- 从当年的1月1日开始，兑换减少积分+转移转出积分
            ,discount_date -- 指打折日期
            ,last_dis_date -- 
            ,last_init_date -- 
            ,drop_card_date -- 
            ,remark -- 
            ,issue_branch -- 
            ,last_his_valid_point -- 
            ,last_ope_time -- 
            ,last_dis_time -- 
            ,last_init_time -- 
            ,customer_name -- 
            ,point_type -- 01-标准积分； 02-个人存款积分； 03-个人贷款积分 ； 04-个人理财积分； 05-红利； 06-里程；
            ,state -- 01-正常； 02-冻结；
            ,operator_id -- 
            ,author_id -- 
            ,operate_date -- 
            ,operate_time -- 
            ,expand_1 -- 
            ,expand_2 -- 
            ,expand_3 -- 
            ,expand_4 -- 
            ,expand_5 -- 
            ,is_valid -- 0-有效 1-失效
            ,author_name -- 
            ,author_real_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.card_no, o.card_no) as card_no -- 
    ,nvl(n.customer_no, o.customer_no) as customer_no -- 
    ,nvl(n.id_card, o.id_card) as id_card -- 
    ,nvl(n.custom_type, o.custom_type) as custom_type -- 
    ,nvl(n.card_type, o.card_type) as card_type -- 
    ,nvl(n.card_product, o.card_product) as card_product -- 
    ,nvl(n.cur_valid_point, o.cur_valid_point) as cur_valid_point -- 
    ,nvl(n.his_valid_point, o.his_valid_point) as his_valid_point -- 
    ,nvl(n.total_valid_point, o.total_valid_point) as total_valid_point -- 当前可用积分+历史可用积分
    ,nvl(n.used_point, o.used_point) as used_point -- 从开卡开始，兑换减少积分+转移转出积分
    ,nvl(n.cut_point_used, o.cut_point_used) as cut_point_used -- 
    ,nvl(n.total_point, o.total_point) as total_point -- 从开卡开始，消费增加积分+调整增加积分-调整减少积分+转移转入积分
    ,nvl(n.due_point, o.due_point) as due_point -- 已经做了结转，但是还没做打折的积分
    ,nvl(n.year_used_point, o.year_used_point) as year_used_point -- 从当年的1月1日开始，兑换减少积分+转移转出积分
    ,nvl(n.discount_date, o.discount_date) as discount_date -- 指打折日期
    ,nvl(n.last_dis_date, o.last_dis_date) as last_dis_date -- 
    ,nvl(n.last_init_date, o.last_init_date) as last_init_date -- 
    ,nvl(n.drop_card_date, o.drop_card_date) as drop_card_date -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.issue_branch, o.issue_branch) as issue_branch -- 
    ,nvl(n.last_his_valid_point, o.last_his_valid_point) as last_his_valid_point -- 
    ,nvl(n.last_ope_time, o.last_ope_time) as last_ope_time -- 
    ,nvl(n.last_dis_time, o.last_dis_time) as last_dis_time -- 
    ,nvl(n.last_init_time, o.last_init_time) as last_init_time -- 
    ,nvl(n.customer_name, o.customer_name) as customer_name -- 
    ,nvl(n.point_type, o.point_type) as point_type -- 01-标准积分； 02-个人存款积分； 03-个人贷款积分 ； 04-个人理财积分； 05-红利； 06-里程；
    ,nvl(n.state, o.state) as state -- 01-正常； 02-冻结；
    ,nvl(n.operator_id, o.operator_id) as operator_id -- 
    ,nvl(n.author_id, o.author_id) as author_id -- 
    ,nvl(n.operate_date, o.operate_date) as operate_date -- 
    ,nvl(n.operate_time, o.operate_time) as operate_time -- 
    ,nvl(n.expand_1, o.expand_1) as expand_1 -- 
    ,nvl(n.expand_2, o.expand_2) as expand_2 -- 
    ,nvl(n.expand_3, o.expand_3) as expand_3 -- 
    ,nvl(n.expand_4, o.expand_4) as expand_4 -- 
    ,nvl(n.expand_5, o.expand_5) as expand_5 -- 
    ,nvl(n.is_valid, o.is_valid) as is_valid -- 0-有效 1-失效
    ,nvl(n.author_name, o.author_name) as author_name -- 
    ,nvl(n.author_real_name, o.author_real_name) as author_real_name -- 
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.cpms_t_account_point_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.cpms_t_account_point where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.branch_no <> n.branch_no
        or o.card_no <> n.card_no
        or o.customer_no <> n.customer_no
        or o.id_card <> n.id_card
        or o.custom_type <> n.custom_type
        or o.card_type <> n.card_type
        or o.card_product <> n.card_product
        or o.cur_valid_point <> n.cur_valid_point
        or o.his_valid_point <> n.his_valid_point
        or o.total_valid_point <> n.total_valid_point
        or o.used_point <> n.used_point
        or o.cut_point_used <> n.cut_point_used
        or o.total_point <> n.total_point
        or o.due_point <> n.due_point
        or o.year_used_point <> n.year_used_point
        or o.discount_date <> n.discount_date
        or o.last_dis_date <> n.last_dis_date
        or o.last_init_date <> n.last_init_date
        or o.drop_card_date <> n.drop_card_date
        or o.remark <> n.remark
        or o.issue_branch <> n.issue_branch
        or o.last_his_valid_point <> n.last_his_valid_point
        or o.last_ope_time <> n.last_ope_time
        or o.last_dis_time <> n.last_dis_time
        or o.last_init_time <> n.last_init_time
        or o.customer_name <> n.customer_name
        or o.point_type <> n.point_type
        or o.state <> n.state
        or o.operator_id <> n.operator_id
        or o.author_id <> n.author_id
        or o.operate_date <> n.operate_date
        or o.operate_time <> n.operate_time
        or o.expand_1 <> n.expand_1
        or o.expand_2 <> n.expand_2
        or o.expand_3 <> n.expand_3
        or o.expand_4 <> n.expand_4
        or o.expand_5 <> n.expand_5
        or o.is_valid <> n.is_valid
        or o.author_name <> n.author_name
        or o.author_real_name <> n.author_real_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.cpms_t_account_point_cl(
            id -- 
            ,branch_no -- 
            ,card_no -- 
            ,customer_no -- 
            ,id_card -- 
            ,custom_type -- 
            ,card_type -- 
            ,card_product -- 
            ,cur_valid_point -- 
            ,his_valid_point -- 
            ,total_valid_point -- 当前可用积分+历史可用积分
            ,used_point -- 从开卡开始，兑换减少积分+转移转出积分
            ,cut_point_used -- 
            ,total_point -- 从开卡开始，消费增加积分+调整增加积分-调整减少积分+转移转入积分
            ,due_point -- 已经做了结转，但是还没做打折的积分
            ,year_used_point -- 从当年的1月1日开始，兑换减少积分+转移转出积分
            ,discount_date -- 指打折日期
            ,last_dis_date -- 
            ,last_init_date -- 
            ,drop_card_date -- 
            ,remark -- 
            ,issue_branch -- 
            ,last_his_valid_point -- 
            ,last_ope_time -- 
            ,last_dis_time -- 
            ,last_init_time -- 
            ,customer_name -- 
            ,point_type -- 01-标准积分； 02-个人存款积分； 03-个人贷款积分 ； 04-个人理财积分； 05-红利； 06-里程；
            ,state -- 01-正常； 02-冻结；
            ,operator_id -- 
            ,author_id -- 
            ,operate_date -- 
            ,operate_time -- 
            ,expand_1 -- 
            ,expand_2 -- 
            ,expand_3 -- 
            ,expand_4 -- 
            ,expand_5 -- 
            ,is_valid -- 0-有效 1-失效
            ,author_name -- 
            ,author_real_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.cpms_t_account_point_op(
            id -- 
            ,branch_no -- 
            ,card_no -- 
            ,customer_no -- 
            ,id_card -- 
            ,custom_type -- 
            ,card_type -- 
            ,card_product -- 
            ,cur_valid_point -- 
            ,his_valid_point -- 
            ,total_valid_point -- 当前可用积分+历史可用积分
            ,used_point -- 从开卡开始，兑换减少积分+转移转出积分
            ,cut_point_used -- 
            ,total_point -- 从开卡开始，消费增加积分+调整增加积分-调整减少积分+转移转入积分
            ,due_point -- 已经做了结转，但是还没做打折的积分
            ,year_used_point -- 从当年的1月1日开始，兑换减少积分+转移转出积分
            ,discount_date -- 指打折日期
            ,last_dis_date -- 
            ,last_init_date -- 
            ,drop_card_date -- 
            ,remark -- 
            ,issue_branch -- 
            ,last_his_valid_point -- 
            ,last_ope_time -- 
            ,last_dis_time -- 
            ,last_init_time -- 
            ,customer_name -- 
            ,point_type -- 01-标准积分； 02-个人存款积分； 03-个人贷款积分 ； 04-个人理财积分； 05-红利； 06-里程；
            ,state -- 01-正常； 02-冻结；
            ,operator_id -- 
            ,author_id -- 
            ,operate_date -- 
            ,operate_time -- 
            ,expand_1 -- 
            ,expand_2 -- 
            ,expand_3 -- 
            ,expand_4 -- 
            ,expand_5 -- 
            ,is_valid -- 0-有效 1-失效
            ,author_name -- 
            ,author_real_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.branch_no -- 
    ,o.card_no -- 
    ,o.customer_no -- 
    ,o.id_card -- 
    ,o.custom_type -- 
    ,o.card_type -- 
    ,o.card_product -- 
    ,o.cur_valid_point -- 
    ,o.his_valid_point -- 
    ,o.total_valid_point -- 当前可用积分+历史可用积分
    ,o.used_point -- 从开卡开始，兑换减少积分+转移转出积分
    ,o.cut_point_used -- 
    ,o.total_point -- 从开卡开始，消费增加积分+调整增加积分-调整减少积分+转移转入积分
    ,o.due_point -- 已经做了结转，但是还没做打折的积分
    ,o.year_used_point -- 从当年的1月1日开始，兑换减少积分+转移转出积分
    ,o.discount_date -- 指打折日期
    ,o.last_dis_date -- 
    ,o.last_init_date -- 
    ,o.drop_card_date -- 
    ,o.remark -- 
    ,o.issue_branch -- 
    ,o.last_his_valid_point -- 
    ,o.last_ope_time -- 
    ,o.last_dis_time -- 
    ,o.last_init_time -- 
    ,o.customer_name -- 
    ,o.point_type -- 01-标准积分； 02-个人存款积分； 03-个人贷款积分 ； 04-个人理财积分； 05-红利； 06-里程；
    ,o.state -- 01-正常； 02-冻结；
    ,o.operator_id -- 
    ,o.author_id -- 
    ,o.operate_date -- 
    ,o.operate_time -- 
    ,o.expand_1 -- 
    ,o.expand_2 -- 
    ,o.expand_3 -- 
    ,o.expand_4 -- 
    ,o.expand_5 -- 
    ,o.is_valid -- 0-有效 1-失效
    ,o.author_name -- 
    ,o.author_real_name -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.cpms_t_account_point_bk o
    left join ${iol_schema}.cpms_t_account_point_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.cpms_t_account_point_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.cpms_t_account_point;

-- 4.2 exchange partition
alter table ${iol_schema}.cpms_t_account_point exchange partition p_19000101 with table ${iol_schema}.cpms_t_account_point_cl;
alter table ${iol_schema}.cpms_t_account_point exchange partition p_20991231 with table ${iol_schema}.cpms_t_account_point_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cpms_t_account_point to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cpms_t_account_point_op purge;
drop table ${iol_schema}.cpms_t_account_point_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.cpms_t_account_point_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cpms_t_account_point',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
