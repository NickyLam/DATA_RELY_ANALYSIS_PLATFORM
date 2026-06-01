/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_vtrd_fzywhq
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
create table ${iol_schema}.ibms_vtrd_fzywhq_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_vtrd_fzywhq
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_vtrd_fzywhq_op purge;
drop table ${iol_schema}.ibms_vtrd_fzywhq_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_fzywhq_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_vtrd_fzywhq where 0=1;

create table ${iol_schema}.ibms_vtrd_fzywhq_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_vtrd_fzywhq where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_vtrd_fzywhq_cl(
            obj_id -- 核算ID
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,intordid -- 交易单号
            ,secu_accname -- 投组单元
            ,secu_acctg_type_name -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,orddate -- 交易日期
            ,partyname -- 交易对手
            ,t_path -- 交易对手客户分类
            ,currency -- 币种
            ,ordamount -- 本金发生额
            ,bnd_aiamount -- 利息发生额
            ,bnd_ytm -- 执行利率/参考收益率
            ,open_date -- 签约起始日
            ,end_date -- 签约到期日
            ,first_payment_date -- 首次付息日
            ,payment_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,real_amount -- 余额
            ,business_category_name -- 所属行业门类
            ,business_category_min_name -- 所属行业大类
            ,s_grade -- 债项/主体评级
            ,exhacc -- 本方账户
            ,party_acct_code -- 交易对手账户
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,subj_code -- 本金科目号
            ,ibs -- 数据来源
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_vtrd_fzywhq_op(
            obj_id -- 核算ID
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,intordid -- 交易单号
            ,secu_accname -- 投组单元
            ,secu_acctg_type_name -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,orddate -- 交易日期
            ,partyname -- 交易对手
            ,t_path -- 交易对手客户分类
            ,currency -- 币种
            ,ordamount -- 本金发生额
            ,bnd_aiamount -- 利息发生额
            ,bnd_ytm -- 执行利率/参考收益率
            ,open_date -- 签约起始日
            ,end_date -- 签约到期日
            ,first_payment_date -- 首次付息日
            ,payment_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,real_amount -- 余额
            ,business_category_name -- 所属行业门类
            ,business_category_min_name -- 所属行业大类
            ,s_grade -- 债项/主体评级
            ,exhacc -- 本方账户
            ,party_acct_code -- 交易对手账户
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,subj_code -- 本金科目号
            ,ibs -- 数据来源
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.obj_id, o.obj_id) as obj_id -- 核算ID
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 余额日期
    ,nvl(n.org_id, o.org_id) as org_id -- 机构号
    ,nvl(n.intordid, o.intordid) as intordid -- 交易单号
    ,nvl(n.secu_accname, o.secu_accname) as secu_accname -- 投组单元
    ,nvl(n.secu_acctg_type_name, o.secu_acctg_type_name) as secu_acctg_type_name -- 会计分类
    ,nvl(n.p_type_name, o.p_type_name) as p_type_name -- 产品类型
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类
    ,nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.i_name, o.i_name) as i_name -- 金融工具名称
    ,nvl(n.orddate, o.orddate) as orddate -- 交易日期
    ,nvl(n.partyname, o.partyname) as partyname -- 交易对手
    ,nvl(n.t_path, o.t_path) as t_path -- 交易对手客户分类
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.ordamount, o.ordamount) as ordamount -- 本金发生额
    ,nvl(n.bnd_aiamount, o.bnd_aiamount) as bnd_aiamount -- 利息发生额
    ,nvl(n.bnd_ytm, o.bnd_ytm) as bnd_ytm -- 执行利率/参考收益率
    ,nvl(n.open_date, o.open_date) as open_date -- 签约起始日
    ,nvl(n.end_date, o.end_date) as end_date -- 签约到期日
    ,nvl(n.first_payment_date, o.first_payment_date) as first_payment_date -- 首次付息日
    ,nvl(n.payment_freq_name, o.payment_freq_name) as payment_freq_name -- 付息频率
    ,nvl(n.daycount_name, o.daycount_name) as daycount_name -- 计息基准
    ,nvl(n.coupon_type_name, o.coupon_type_name) as coupon_type_name -- 息票类型
    ,nvl(n.real_amount, o.real_amount) as real_amount -- 余额
    ,nvl(n.business_category_name, o.business_category_name) as business_category_name -- 所属行业门类
    ,nvl(n.business_category_min_name, o.business_category_min_name) as business_category_min_name -- 所属行业大类
    ,nvl(n.s_grade, o.s_grade) as s_grade -- 债项/主体评级
    ,nvl(n.exhacc, o.exhacc) as exhacc -- 本方账户
    ,nvl(n.party_acct_code, o.party_acct_code) as party_acct_code -- 交易对手账户
    ,nvl(n.trader, o.trader) as trader -- 经办人
    ,nvl(n.op_user_name1, o.op_user_name1) as op_user_name1 -- 总行经办人
    ,nvl(n.op_user_name2, o.op_user_name2) as op_user_name2 -- 总行复核人
    ,nvl(n.subj_code, o.subj_code) as subj_code -- 本金科目号
    ,nvl(n.ibs, o.ibs) as ibs -- 数据来源
    ,case when
            n.intordid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.intordid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.intordid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_vtrd_fzywhq_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_vtrd_fzywhq where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.intordid = n.intordid
where (
        o.intordid is null
    )
    or (
        n.intordid is null
    )
    or (
        o.obj_id <> n.obj_id
        or o.beg_date <> n.beg_date
        or o.org_id <> n.org_id
        or o.secu_accname <> n.secu_accname
        or o.secu_acctg_type_name <> n.secu_acctg_type_name
        or o.p_type_name <> n.p_type_name
        or o.p_class <> n.p_class
        or o.i_code <> n.i_code
        or o.i_name <> n.i_name
        or o.orddate <> n.orddate
        or o.partyname <> n.partyname
        or o.t_path <> n.t_path
        or o.currency <> n.currency
        or o.ordamount <> n.ordamount
        or o.bnd_aiamount <> n.bnd_aiamount
        or o.bnd_ytm <> n.bnd_ytm
        or o.open_date <> n.open_date
        or o.end_date <> n.end_date
        or o.first_payment_date <> n.first_payment_date
        or o.payment_freq_name <> n.payment_freq_name
        or o.daycount_name <> n.daycount_name
        or o.coupon_type_name <> n.coupon_type_name
        or o.real_amount <> n.real_amount
        or o.business_category_name <> n.business_category_name
        or o.business_category_min_name <> n.business_category_min_name
        or o.s_grade <> n.s_grade
        or o.exhacc <> n.exhacc
        or o.party_acct_code <> n.party_acct_code
        or o.trader <> n.trader
        or o.op_user_name1 <> n.op_user_name1
        or o.op_user_name2 <> n.op_user_name2
        or o.subj_code <> n.subj_code
        or o.ibs <> n.ibs
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_vtrd_fzywhq_cl(
            obj_id -- 核算ID
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,intordid -- 交易单号
            ,secu_accname -- 投组单元
            ,secu_acctg_type_name -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,orddate -- 交易日期
            ,partyname -- 交易对手
            ,t_path -- 交易对手客户分类
            ,currency -- 币种
            ,ordamount -- 本金发生额
            ,bnd_aiamount -- 利息发生额
            ,bnd_ytm -- 执行利率/参考收益率
            ,open_date -- 签约起始日
            ,end_date -- 签约到期日
            ,first_payment_date -- 首次付息日
            ,payment_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,real_amount -- 余额
            ,business_category_name -- 所属行业门类
            ,business_category_min_name -- 所属行业大类
            ,s_grade -- 债项/主体评级
            ,exhacc -- 本方账户
            ,party_acct_code -- 交易对手账户
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,subj_code -- 本金科目号
            ,ibs -- 数据来源
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_vtrd_fzywhq_op(
            obj_id -- 核算ID
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,intordid -- 交易单号
            ,secu_accname -- 投组单元
            ,secu_acctg_type_name -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,orddate -- 交易日期
            ,partyname -- 交易对手
            ,t_path -- 交易对手客户分类
            ,currency -- 币种
            ,ordamount -- 本金发生额
            ,bnd_aiamount -- 利息发生额
            ,bnd_ytm -- 执行利率/参考收益率
            ,open_date -- 签约起始日
            ,end_date -- 签约到期日
            ,first_payment_date -- 首次付息日
            ,payment_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,real_amount -- 余额
            ,business_category_name -- 所属行业门类
            ,business_category_min_name -- 所属行业大类
            ,s_grade -- 债项/主体评级
            ,exhacc -- 本方账户
            ,party_acct_code -- 交易对手账户
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,subj_code -- 本金科目号
            ,ibs -- 数据来源
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.obj_id -- 核算ID
    ,o.beg_date -- 余额日期
    ,o.org_id -- 机构号
    ,o.intordid -- 交易单号
    ,o.secu_accname -- 投组单元
    ,o.secu_acctg_type_name -- 会计分类
    ,o.p_type_name -- 产品类型
    ,o.p_class -- 产品分类
    ,o.i_code -- 金融工具代码
    ,o.i_name -- 金融工具名称
    ,o.orddate -- 交易日期
    ,o.partyname -- 交易对手
    ,o.t_path -- 交易对手客户分类
    ,o.currency -- 币种
    ,o.ordamount -- 本金发生额
    ,o.bnd_aiamount -- 利息发生额
    ,o.bnd_ytm -- 执行利率/参考收益率
    ,o.open_date -- 签约起始日
    ,o.end_date -- 签约到期日
    ,o.first_payment_date -- 首次付息日
    ,o.payment_freq_name -- 付息频率
    ,o.daycount_name -- 计息基准
    ,o.coupon_type_name -- 息票类型
    ,o.real_amount -- 余额
    ,o.business_category_name -- 所属行业门类
    ,o.business_category_min_name -- 所属行业大类
    ,o.s_grade -- 债项/主体评级
    ,o.exhacc -- 本方账户
    ,o.party_acct_code -- 交易对手账户
    ,o.trader -- 经办人
    ,o.op_user_name1 -- 总行经办人
    ,o.op_user_name2 -- 总行复核人
    ,o.subj_code -- 本金科目号
    ,o.ibs -- 数据来源
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_vtrd_fzywhq_bk o
    left join ${iol_schema}.ibms_vtrd_fzywhq_op n
        on
            o.intordid = n.intordid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_vtrd_fzywhq_cl d
        on
            o.intordid = d.intordid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_vtrd_fzywhq;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_vtrd_fzywhq') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_vtrd_fzywhq drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_vtrd_fzywhq add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_vtrd_fzywhq exchange partition p_${batch_date} with table ${iol_schema}.ibms_vtrd_fzywhq_cl;
alter table ${iol_schema}.ibms_vtrd_fzywhq exchange partition p_20991231 with table ${iol_schema}.ibms_vtrd_fzywhq_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_vtrd_fzywhq to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_vtrd_fzywhq_op purge;
drop table ${iol_schema}.ibms_vtrd_fzywhq_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_vtrd_fzywhq_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_vtrd_fzywhq',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
