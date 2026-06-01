/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_bok_stat_det_posiiton
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
create table ${iol_schema}.fams_bok_stat_det_posiiton_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_bok_stat_det_posiiton;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_stat_det_posiiton_op purge;
drop table ${iol_schema}.fams_bok_stat_det_posiiton_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_stat_det_posiiton_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_stat_det_posiiton where 0=1;

create table ${iol_schema}.fams_bok_stat_det_posiiton_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_stat_det_posiiton where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_stat_det_posiiton_cl(
            bookset_id -- 账套代码
            ,happen_date -- 发生日期
            ,book_date -- 入账日期
            ,bok_detail_id -- 账务明细代码
            ,book_summary_order -- 处理序列
            ,bookset_date -- 账套日期
            ,pos_amt -- 当前持仓
            ,int_rate -- 计提利率
            ,dailydsc_yield -- 日摊销收益率
            ,tdy_intincexp_add -- 当日发生应计利息
            ,tdy_intincexp -- 当日累计应计利息余额
            ,finprod_type -- 金融产品类型
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,chl_id -- 通道代码
            ,inv_aim -- 投资目的
            ,tdy_position -- 当日计提份额
            ,tdy_cost_amt -- 当日成本
            ,tdy_float_ingpl -- 当日公允价值变动
            ,end_days_1 -- 剩余期限
            ,end_days_2 -- 剩余存续期限
            ,end_days_cost_amt -- 剩余期限用成本
            ,busi_id -- 业务明细代码
            ,val_date -- 行情日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,tdy_float_ingpl_exp -- 当日累计公允价值变动
            ,ccy -- 币种
            ,b_ccy -- 本位币
            ,tdy_intincexp_add_b -- 当日发生应计利息_本位币
            ,tdy_cost_amt_b -- 当日成本_本位币
            ,tdy_float_ingpl_b -- 当日公允价值变动_本位币
            ,tdy_float_ingpl_exp_b -- 当日累计公允价值变动_本位币
            ,tdy_intincexp_b -- 当日累计应计利息余额_本位币
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_bok_stat_det_posiiton_op(
            bookset_id -- 账套代码
            ,happen_date -- 发生日期
            ,book_date -- 入账日期
            ,bok_detail_id -- 账务明细代码
            ,book_summary_order -- 处理序列
            ,bookset_date -- 账套日期
            ,pos_amt -- 当前持仓
            ,int_rate -- 计提利率
            ,dailydsc_yield -- 日摊销收益率
            ,tdy_intincexp_add -- 当日发生应计利息
            ,tdy_intincexp -- 当日累计应计利息余额
            ,finprod_type -- 金融产品类型
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,chl_id -- 通道代码
            ,inv_aim -- 投资目的
            ,tdy_position -- 当日计提份额
            ,tdy_cost_amt -- 当日成本
            ,tdy_float_ingpl -- 当日公允价值变动
            ,end_days_1 -- 剩余期限
            ,end_days_2 -- 剩余存续期限
            ,end_days_cost_amt -- 剩余期限用成本
            ,busi_id -- 业务明细代码
            ,val_date -- 行情日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,tdy_float_ingpl_exp -- 当日累计公允价值变动
            ,ccy -- 币种
            ,b_ccy -- 本位币
            ,tdy_intincexp_add_b -- 当日发生应计利息_本位币
            ,tdy_cost_amt_b -- 当日成本_本位币
            ,tdy_float_ingpl_b -- 当日公允价值变动_本位币
            ,tdy_float_ingpl_exp_b -- 当日累计公允价值变动_本位币
            ,tdy_intincexp_b -- 当日累计应计利息余额_本位币
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bookset_id, o.bookset_id) as bookset_id -- 账套代码
    ,nvl(n.happen_date, o.happen_date) as happen_date -- 发生日期
    ,nvl(n.book_date, o.book_date) as book_date -- 入账日期
    ,nvl(n.bok_detail_id, o.bok_detail_id) as bok_detail_id -- 账务明细代码
    ,nvl(n.book_summary_order, o.book_summary_order) as book_summary_order -- 处理序列
    ,nvl(n.bookset_date, o.bookset_date) as bookset_date -- 账套日期
    ,nvl(n.pos_amt, o.pos_amt) as pos_amt -- 当前持仓
    ,nvl(n.int_rate, o.int_rate) as int_rate -- 计提利率
    ,nvl(n.dailydsc_yield, o.dailydsc_yield) as dailydsc_yield -- 日摊销收益率
    ,nvl(n.tdy_intincexp_add, o.tdy_intincexp_add) as tdy_intincexp_add -- 当日发生应计利息
    ,nvl(n.tdy_intincexp, o.tdy_intincexp) as tdy_intincexp -- 当日累计应计利息余额
    ,nvl(n.finprod_type, o.finprod_type) as finprod_type -- 金融产品类型
    ,nvl(n.vdate, o.vdate) as vdate -- 起息日
    ,nvl(n.mdate, o.mdate) as mdate -- 到期日
    ,nvl(n.chl_id, o.chl_id) as chl_id -- 通道代码
    ,nvl(n.inv_aim, o.inv_aim) as inv_aim -- 投资目的
    ,nvl(n.tdy_position, o.tdy_position) as tdy_position -- 当日计提份额
    ,nvl(n.tdy_cost_amt, o.tdy_cost_amt) as tdy_cost_amt -- 当日成本
    ,nvl(n.tdy_float_ingpl, o.tdy_float_ingpl) as tdy_float_ingpl -- 当日公允价值变动
    ,nvl(n.end_days_1, o.end_days_1) as end_days_1 -- 剩余期限
    ,nvl(n.end_days_2, o.end_days_2) as end_days_2 -- 剩余存续期限
    ,nvl(n.end_days_cost_amt, o.end_days_cost_amt) as end_days_cost_amt -- 剩余期限用成本
    ,nvl(n.busi_id, o.busi_id) as busi_id -- 业务明细代码
    ,nvl(n.val_date, o.val_date) as val_date -- 行情日期
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.tdy_float_ingpl_exp, o.tdy_float_ingpl_exp) as tdy_float_ingpl_exp -- 当日累计公允价值变动
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.b_ccy, o.b_ccy) as b_ccy -- 本位币
    ,nvl(n.tdy_intincexp_add_b, o.tdy_intincexp_add_b) as tdy_intincexp_add_b -- 当日发生应计利息_本位币
    ,nvl(n.tdy_cost_amt_b, o.tdy_cost_amt_b) as tdy_cost_amt_b -- 当日成本_本位币
    ,nvl(n.tdy_float_ingpl_b, o.tdy_float_ingpl_b) as tdy_float_ingpl_b -- 当日公允价值变动_本位币
    ,nvl(n.tdy_float_ingpl_exp_b, o.tdy_float_ingpl_exp_b) as tdy_float_ingpl_exp_b -- 当日累计公允价值变动_本位币
    ,nvl(n.tdy_intincexp_b, o.tdy_intincexp_b) as tdy_intincexp_b -- 当日累计应计利息余额_本位币
    ,case when
            n.bookset_id is null
            and n.happen_date is null
            and n.book_date is null
            and n.bok_detail_id is null
            and n.book_summary_order is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bookset_id is null
            and n.happen_date is null
            and n.book_date is null
            and n.bok_detail_id is null
            and n.book_summary_order is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bookset_id is null
            and n.happen_date is null
            and n.book_date is null
            and n.bok_detail_id is null
            and n.book_summary_order is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_bok_stat_det_posiiton_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_bok_stat_det_posiiton where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bookset_id = n.bookset_id
            and o.happen_date = n.happen_date
            and o.book_date = n.book_date
            and o.bok_detail_id = n.bok_detail_id
            and o.book_summary_order = n.book_summary_order
where (
        o.bookset_id is null
        and o.happen_date is null
        and o.book_date is null
        and o.bok_detail_id is null
        and o.book_summary_order is null
    )
    or (
        n.bookset_id is null
        and n.happen_date is null
        and n.book_date is null
        and n.bok_detail_id is null
        and n.book_summary_order is null
    )
    or (
        o.bookset_date <> n.bookset_date
        or o.pos_amt <> n.pos_amt
        or o.int_rate <> n.int_rate
        or o.dailydsc_yield <> n.dailydsc_yield
        or o.tdy_intincexp_add <> n.tdy_intincexp_add
        or o.tdy_intincexp <> n.tdy_intincexp
        or o.finprod_type <> n.finprod_type
        or o.vdate <> n.vdate
        or o.mdate <> n.mdate
        or o.chl_id <> n.chl_id
        or o.inv_aim <> n.inv_aim
        or o.tdy_position <> n.tdy_position
        or o.tdy_cost_amt <> n.tdy_cost_amt
        or o.tdy_float_ingpl <> n.tdy_float_ingpl
        or o.end_days_1 <> n.end_days_1
        or o.end_days_2 <> n.end_days_2
        or o.end_days_cost_amt <> n.end_days_cost_amt
        or o.busi_id <> n.busi_id
        or o.val_date <> n.val_date
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.tdy_float_ingpl_exp <> n.tdy_float_ingpl_exp
        or o.ccy <> n.ccy
        or o.b_ccy <> n.b_ccy
        or o.tdy_intincexp_add_b <> n.tdy_intincexp_add_b
        or o.tdy_cost_amt_b <> n.tdy_cost_amt_b
        or o.tdy_float_ingpl_b <> n.tdy_float_ingpl_b
        or o.tdy_float_ingpl_exp_b <> n.tdy_float_ingpl_exp_b
        or o.tdy_intincexp_b <> n.tdy_intincexp_b
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_stat_det_posiiton_cl(
            bookset_id -- 账套代码
            ,happen_date -- 发生日期
            ,book_date -- 入账日期
            ,bok_detail_id -- 账务明细代码
            ,book_summary_order -- 处理序列
            ,bookset_date -- 账套日期
            ,pos_amt -- 当前持仓
            ,int_rate -- 计提利率
            ,dailydsc_yield -- 日摊销收益率
            ,tdy_intincexp_add -- 当日发生应计利息
            ,tdy_intincexp -- 当日累计应计利息余额
            ,finprod_type -- 金融产品类型
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,chl_id -- 通道代码
            ,inv_aim -- 投资目的
            ,tdy_position -- 当日计提份额
            ,tdy_cost_amt -- 当日成本
            ,tdy_float_ingpl -- 当日公允价值变动
            ,end_days_1 -- 剩余期限
            ,end_days_2 -- 剩余存续期限
            ,end_days_cost_amt -- 剩余期限用成本
            ,busi_id -- 业务明细代码
            ,val_date -- 行情日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,tdy_float_ingpl_exp -- 当日累计公允价值变动
            ,ccy -- 币种
            ,b_ccy -- 本位币
            ,tdy_intincexp_add_b -- 当日发生应计利息_本位币
            ,tdy_cost_amt_b -- 当日成本_本位币
            ,tdy_float_ingpl_b -- 当日公允价值变动_本位币
            ,tdy_float_ingpl_exp_b -- 当日累计公允价值变动_本位币
            ,tdy_intincexp_b -- 当日累计应计利息余额_本位币
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_bok_stat_det_posiiton_op(
            bookset_id -- 账套代码
            ,happen_date -- 发生日期
            ,book_date -- 入账日期
            ,bok_detail_id -- 账务明细代码
            ,book_summary_order -- 处理序列
            ,bookset_date -- 账套日期
            ,pos_amt -- 当前持仓
            ,int_rate -- 计提利率
            ,dailydsc_yield -- 日摊销收益率
            ,tdy_intincexp_add -- 当日发生应计利息
            ,tdy_intincexp -- 当日累计应计利息余额
            ,finprod_type -- 金融产品类型
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,chl_id -- 通道代码
            ,inv_aim -- 投资目的
            ,tdy_position -- 当日计提份额
            ,tdy_cost_amt -- 当日成本
            ,tdy_float_ingpl -- 当日公允价值变动
            ,end_days_1 -- 剩余期限
            ,end_days_2 -- 剩余存续期限
            ,end_days_cost_amt -- 剩余期限用成本
            ,busi_id -- 业务明细代码
            ,val_date -- 行情日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,tdy_float_ingpl_exp -- 当日累计公允价值变动
            ,ccy -- 币种
            ,b_ccy -- 本位币
            ,tdy_intincexp_add_b -- 当日发生应计利息_本位币
            ,tdy_cost_amt_b -- 当日成本_本位币
            ,tdy_float_ingpl_b -- 当日公允价值变动_本位币
            ,tdy_float_ingpl_exp_b -- 当日累计公允价值变动_本位币
            ,tdy_intincexp_b -- 当日累计应计利息余额_本位币
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bookset_id -- 账套代码
    ,o.happen_date -- 发生日期
    ,o.book_date -- 入账日期
    ,o.bok_detail_id -- 账务明细代码
    ,o.book_summary_order -- 处理序列
    ,o.bookset_date -- 账套日期
    ,o.pos_amt -- 当前持仓
    ,o.int_rate -- 计提利率
    ,o.dailydsc_yield -- 日摊销收益率
    ,o.tdy_intincexp_add -- 当日发生应计利息
    ,o.tdy_intincexp -- 当日累计应计利息余额
    ,o.finprod_type -- 金融产品类型
    ,o.vdate -- 起息日
    ,o.mdate -- 到期日
    ,o.chl_id -- 通道代码
    ,o.inv_aim -- 投资目的
    ,o.tdy_position -- 当日计提份额
    ,o.tdy_cost_amt -- 当日成本
    ,o.tdy_float_ingpl -- 当日公允价值变动
    ,o.end_days_1 -- 剩余期限
    ,o.end_days_2 -- 剩余存续期限
    ,o.end_days_cost_amt -- 剩余期限用成本
    ,o.busi_id -- 业务明细代码
    ,o.val_date -- 行情日期
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.tdy_float_ingpl_exp -- 当日累计公允价值变动
    ,o.ccy -- 币种
    ,o.b_ccy -- 本位币
    ,o.tdy_intincexp_add_b -- 当日发生应计利息_本位币
    ,o.tdy_cost_amt_b -- 当日成本_本位币
    ,o.tdy_float_ingpl_b -- 当日公允价值变动_本位币
    ,o.tdy_float_ingpl_exp_b -- 当日累计公允价值变动_本位币
    ,o.tdy_intincexp_b -- 当日累计应计利息余额_本位币
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_bok_stat_det_posiiton_bk o
    left join ${iol_schema}.fams_bok_stat_det_posiiton_op n
        on
            o.bookset_id = n.bookset_id
            and o.happen_date = n.happen_date
            and o.book_date = n.book_date
            and o.bok_detail_id = n.bok_detail_id
            and o.book_summary_order = n.book_summary_order
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_bok_stat_det_posiiton_cl d
        on
            o.bookset_id = d.bookset_id
            and o.happen_date = d.happen_date
            and o.book_date = d.book_date
            and o.bok_detail_id = d.bok_detail_id
            and o.book_summary_order = d.book_summary_order
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_bok_stat_det_posiiton;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_bok_stat_det_posiiton exchange partition p_19000101 with table ${iol_schema}.fams_bok_stat_det_posiiton_cl;
alter table ${iol_schema}.fams_bok_stat_det_posiiton exchange partition p_20991231 with table ${iol_schema}.fams_bok_stat_det_posiiton_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_bok_stat_det_posiiton to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_stat_det_posiiton_op purge;
drop table ${iol_schema}.fams_bok_stat_det_posiiton_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_bok_stat_det_posiiton_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_bok_stat_det_posiiton',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
