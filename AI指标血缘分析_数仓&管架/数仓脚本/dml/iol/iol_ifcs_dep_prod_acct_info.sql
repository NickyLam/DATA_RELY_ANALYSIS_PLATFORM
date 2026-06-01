/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_dep_prod_acct_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;
/*
-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ifcs_dep_prod_acct_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifcs_dep_prod_acct_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');
*/
-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifcs_dep_prod_acct_info_op purge;
drop table ${iol_schema}.ifcs_dep_prod_acct_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_dep_prod_acct_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_dep_prod_acct_info where 0=1;

create table ${iol_schema}.ifcs_dep_prod_acct_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_dep_prod_acct_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifcs_dep_prod_acct_info_cl(
            part_id -- HASH分区ID
            ,dep_prod_sub_acct_id -- 存款产品分户编号
            ,dep_acct_id -- 存款账户编号
            ,acct_name -- 账户名称
            ,cust_id -- 客户编号
            ,prod_id -- 产品编号
            ,ext_prod_id -- 外部产品代码
            ,dep_acct_status_cd -- 存款账户状态代码
            ,acpt_pay_status -- 收付标志
            ,froz_status -- 冻结状态
            ,stpay_status_cd -- 止付状态
            ,int_accr_flg -- 计息标志
            ,open_acct_dt -- 开户日期
            ,value_dt -- 起息日期
            ,exp_dt -- 到期日期
            ,bal -- 本金金额（余额）
            ,froz_amt -- 冻结金额
            ,stpaybl -- 止付金额
            ,acct_instit_id -- 账务机构编号
            ,open_acct_org_id -- 开户机构编号
            ,open_acct_chn_id -- 开户渠道编号
            ,open_acct_flow_num -- 开户流水号
            ,last_activ_acct_dt -- 上次动户日期
            ,exec_int_rat -- 执行利率
            ,base_rat -- 基准利率
            ,spread_val -- 浮动值（点差值）
            ,close_acct_dt -- 销户日期
            ,close_acct_flow_num -- 销户流水号
            ,pa_ext_cnt -- 部提次数
            ,dep_term_cd -- 存期代码
            ,ext_acct_dt -- 对接行的账务日期
            ,open_acct_ti -- 开户时间
            ,close_acct_ti -- 销户时间
            ,fee_dt -- 费用日期
            ,bind_acct_id -- 微众银行卡号
            ,dps_type_cd -- 储种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifcs_dep_prod_acct_info_op(
            part_id -- HASH分区ID
            ,dep_prod_sub_acct_id -- 存款产品分户编号
            ,dep_acct_id -- 存款账户编号
            ,acct_name -- 账户名称
            ,cust_id -- 客户编号
            ,prod_id -- 产品编号
            ,ext_prod_id -- 外部产品代码
            ,dep_acct_status_cd -- 存款账户状态代码
            ,acpt_pay_status -- 收付标志
            ,froz_status -- 冻结状态
            ,stpay_status_cd -- 止付状态
            ,int_accr_flg -- 计息标志
            ,open_acct_dt -- 开户日期
            ,value_dt -- 起息日期
            ,exp_dt -- 到期日期
            ,bal -- 本金金额（余额）
            ,froz_amt -- 冻结金额
            ,stpaybl -- 止付金额
            ,acct_instit_id -- 账务机构编号
            ,open_acct_org_id -- 开户机构编号
            ,open_acct_chn_id -- 开户渠道编号
            ,open_acct_flow_num -- 开户流水号
            ,last_activ_acct_dt -- 上次动户日期
            ,exec_int_rat -- 执行利率
            ,base_rat -- 基准利率
            ,spread_val -- 浮动值（点差值）
            ,close_acct_dt -- 销户日期
            ,close_acct_flow_num -- 销户流水号
            ,pa_ext_cnt -- 部提次数
            ,dep_term_cd -- 存期代码
            ,ext_acct_dt -- 对接行的账务日期
            ,open_acct_ti -- 开户时间
            ,close_acct_ti -- 销户时间
            ,fee_dt -- 费用日期
            ,bind_acct_id -- 微众银行卡号
            ,dps_type_cd -- 储种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.part_id, o.part_id) as part_id -- HASH分区ID
    ,nvl(n.dep_prod_sub_acct_id, o.dep_prod_sub_acct_id) as dep_prod_sub_acct_id -- 存款产品分户编号
    ,nvl(n.dep_acct_id, o.dep_acct_id) as dep_acct_id -- 存款账户编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.ext_prod_id, o.ext_prod_id) as ext_prod_id -- 外部产品代码
    ,nvl(n.dep_acct_status_cd, o.dep_acct_status_cd) as dep_acct_status_cd -- 存款账户状态代码
    ,nvl(n.acpt_pay_status, o.acpt_pay_status) as acpt_pay_status -- 收付标志
    ,nvl(n.froz_status, o.froz_status) as froz_status -- 冻结状态
    ,nvl(n.stpay_status_cd, o.stpay_status_cd) as stpay_status_cd -- 止付状态
    ,nvl(n.int_accr_flg, o.int_accr_flg) as int_accr_flg -- 计息标志
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.bal, o.bal) as bal -- 本金金额（余额）
    ,nvl(n.froz_amt, o.froz_amt) as froz_amt -- 冻结金额
    ,nvl(n.stpaybl, o.stpaybl) as stpaybl -- 止付金额
    ,nvl(n.acct_instit_id, o.acct_instit_id) as acct_instit_id -- 账务机构编号
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.open_acct_chn_id, o.open_acct_chn_id) as open_acct_chn_id -- 开户渠道编号
    ,nvl(n.open_acct_flow_num, o.open_acct_flow_num) as open_acct_flow_num -- 开户流水号
    ,nvl(n.last_activ_acct_dt, o.last_activ_acct_dt) as last_activ_acct_dt -- 上次动户日期
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.spread_val, o.spread_val) as spread_val -- 浮动值（点差值）
    ,nvl(n.close_acct_dt, o.close_acct_dt) as close_acct_dt -- 销户日期
    ,nvl(n.close_acct_flow_num, o.close_acct_flow_num) as close_acct_flow_num -- 销户流水号
    ,nvl(n.pa_ext_cnt, o.pa_ext_cnt) as pa_ext_cnt -- 部提次数
    ,nvl(n.dep_term_cd, o.dep_term_cd) as dep_term_cd -- 存期代码
    ,nvl(n.ext_acct_dt, o.ext_acct_dt) as ext_acct_dt -- 对接行的账务日期
    ,nvl(n.open_acct_ti, o.open_acct_ti) as open_acct_ti -- 开户时间
    ,nvl(n.close_acct_ti, o.close_acct_ti) as close_acct_ti -- 销户时间
    ,nvl(n.fee_dt, o.fee_dt) as fee_dt -- 费用日期
    ,nvl(n.bind_acct_id, o.bind_acct_id) as bind_acct_id -- 微众银行卡号
    ,nvl(n.dps_type_cd, o.dps_type_cd) as dps_type_cd -- 储种
    ,case when
            n.dep_prod_sub_acct_id is null
            and n.dep_acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.dep_prod_sub_acct_id is null
            and n.dep_acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.dep_prod_sub_acct_id is null
            and n.dep_acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifcs_dep_prod_acct_info where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifcs_dep_prod_acct_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.dep_prod_sub_acct_id = n.dep_prod_sub_acct_id
            and o.dep_acct_id = n.dep_acct_id
where (
        o.dep_prod_sub_acct_id is null
        and o.dep_acct_id is null
    )
    or (
        n.dep_prod_sub_acct_id is null
        and n.dep_acct_id is null
    )
    or (
        o.part_id <> n.part_id
        or o.acct_name <> n.acct_name
        or o.cust_id <> n.cust_id
        or o.prod_id <> n.prod_id
        or o.ext_prod_id <> n.ext_prod_id
        or o.dep_acct_status_cd <> n.dep_acct_status_cd
        or o.acpt_pay_status <> n.acpt_pay_status
        or o.froz_status <> n.froz_status
        or o.stpay_status_cd <> n.stpay_status_cd
        or o.int_accr_flg <> n.int_accr_flg
        or o.open_acct_dt <> n.open_acct_dt
        or o.value_dt <> n.value_dt
        or o.exp_dt <> n.exp_dt
        or o.bal <> n.bal
        or o.froz_amt <> n.froz_amt
        or o.stpaybl <> n.stpaybl
        or o.acct_instit_id <> n.acct_instit_id
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.open_acct_chn_id <> n.open_acct_chn_id
        or o.open_acct_flow_num <> n.open_acct_flow_num
        or o.last_activ_acct_dt <> n.last_activ_acct_dt
        or o.exec_int_rat <> n.exec_int_rat
        or o.base_rat <> n.base_rat
        or o.spread_val <> n.spread_val
        or o.close_acct_dt <> n.close_acct_dt
        or o.close_acct_flow_num <> n.close_acct_flow_num
        or o.pa_ext_cnt <> n.pa_ext_cnt
        or o.dep_term_cd <> n.dep_term_cd
        or o.ext_acct_dt <> n.ext_acct_dt
        or o.open_acct_ti <> n.open_acct_ti
        or o.close_acct_ti <> n.close_acct_ti
        or o.fee_dt <> n.fee_dt
        or o.bind_acct_id <> n.bind_acct_id
        or o.dps_type_cd <> n.dps_type_cd
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifcs_dep_prod_acct_info_cl(
            part_id -- HASH分区ID
            ,dep_prod_sub_acct_id -- 存款产品分户编号
            ,dep_acct_id -- 存款账户编号
            ,acct_name -- 账户名称
            ,cust_id -- 客户编号
            ,prod_id -- 产品编号
            ,ext_prod_id -- 外部产品代码
            ,dep_acct_status_cd -- 存款账户状态代码
            ,acpt_pay_status -- 收付标志
            ,froz_status -- 冻结状态
            ,stpay_status_cd -- 止付状态
            ,int_accr_flg -- 计息标志
            ,open_acct_dt -- 开户日期
            ,value_dt -- 起息日期
            ,exp_dt -- 到期日期
            ,bal -- 本金金额（余额）
            ,froz_amt -- 冻结金额
            ,stpaybl -- 止付金额
            ,acct_instit_id -- 账务机构编号
            ,open_acct_org_id -- 开户机构编号
            ,open_acct_chn_id -- 开户渠道编号
            ,open_acct_flow_num -- 开户流水号
            ,last_activ_acct_dt -- 上次动户日期
            ,exec_int_rat -- 执行利率
            ,base_rat -- 基准利率
            ,spread_val -- 浮动值（点差值）
            ,close_acct_dt -- 销户日期
            ,close_acct_flow_num -- 销户流水号
            ,pa_ext_cnt -- 部提次数
            ,dep_term_cd -- 存期代码
            ,ext_acct_dt -- 对接行的账务日期
            ,open_acct_ti -- 开户时间
            ,close_acct_ti -- 销户时间
            ,fee_dt -- 费用日期
            ,bind_acct_id -- 微众银行卡号
            ,dps_type_cd -- 储种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifcs_dep_prod_acct_info_op(
            part_id -- HASH分区ID
            ,dep_prod_sub_acct_id -- 存款产品分户编号
            ,dep_acct_id -- 存款账户编号
            ,acct_name -- 账户名称
            ,cust_id -- 客户编号
            ,prod_id -- 产品编号
            ,ext_prod_id -- 外部产品代码
            ,dep_acct_status_cd -- 存款账户状态代码
            ,acpt_pay_status -- 收付标志
            ,froz_status -- 冻结状态
            ,stpay_status_cd -- 止付状态
            ,int_accr_flg -- 计息标志
            ,open_acct_dt -- 开户日期
            ,value_dt -- 起息日期
            ,exp_dt -- 到期日期
            ,bal -- 本金金额（余额）
            ,froz_amt -- 冻结金额
            ,stpaybl -- 止付金额
            ,acct_instit_id -- 账务机构编号
            ,open_acct_org_id -- 开户机构编号
            ,open_acct_chn_id -- 开户渠道编号
            ,open_acct_flow_num -- 开户流水号
            ,last_activ_acct_dt -- 上次动户日期
            ,exec_int_rat -- 执行利率
            ,base_rat -- 基准利率
            ,spread_val -- 浮动值（点差值）
            ,close_acct_dt -- 销户日期
            ,close_acct_flow_num -- 销户流水号
            ,pa_ext_cnt -- 部提次数
            ,dep_term_cd -- 存期代码
            ,ext_acct_dt -- 对接行的账务日期
            ,open_acct_ti -- 开户时间
            ,close_acct_ti -- 销户时间
            ,fee_dt -- 费用日期
            ,bind_acct_id -- 微众银行卡号
            ,dps_type_cd -- 储种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.part_id -- HASH分区ID
    ,o.dep_prod_sub_acct_id -- 存款产品分户编号
    ,o.dep_acct_id -- 存款账户编号
    ,o.acct_name -- 账户名称
    ,o.cust_id -- 客户编号
    ,o.prod_id -- 产品编号
    ,o.ext_prod_id -- 外部产品代码
    ,o.dep_acct_status_cd -- 存款账户状态代码
    ,o.acpt_pay_status -- 收付标志
    ,o.froz_status -- 冻结状态
    ,o.stpay_status_cd -- 止付状态
    ,o.int_accr_flg -- 计息标志
    ,o.open_acct_dt -- 开户日期
    ,o.value_dt -- 起息日期
    ,o.exp_dt -- 到期日期
    ,o.bal -- 本金金额（余额）
    ,o.froz_amt -- 冻结金额
    ,o.stpaybl -- 止付金额
    ,o.acct_instit_id -- 账务机构编号
    ,o.open_acct_org_id -- 开户机构编号
    ,o.open_acct_chn_id -- 开户渠道编号
    ,o.open_acct_flow_num -- 开户流水号
    ,o.last_activ_acct_dt -- 上次动户日期
    ,o.exec_int_rat -- 执行利率
    ,o.base_rat -- 基准利率
    ,o.spread_val -- 浮动值（点差值）
    ,o.close_acct_dt -- 销户日期
    ,o.close_acct_flow_num -- 销户流水号
    ,o.pa_ext_cnt -- 部提次数
    ,o.dep_term_cd -- 存期代码
    ,o.ext_acct_dt -- 对接行的账务日期
    ,o.open_acct_ti -- 开户时间
    ,o.close_acct_ti -- 销户时间
    ,o.fee_dt -- 费用日期
    ,o.bind_acct_id -- 微众银行卡号
    ,o.dps_type_cd -- 储种
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
from (select * from ${iol_schema}.ifcs_dep_prod_acct_info where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    left join ${iol_schema}.ifcs_dep_prod_acct_info_op n
        on
            o.dep_prod_sub_acct_id = n.dep_prod_sub_acct_id
            and o.dep_acct_id = n.dep_acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifcs_dep_prod_acct_info_cl d
        on
            o.dep_prod_sub_acct_id = d.dep_prod_sub_acct_id
            and o.dep_acct_id = d.dep_acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifcs_dep_prod_acct_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifcs_dep_prod_acct_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifcs_dep_prod_acct_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifcs_dep_prod_acct_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifcs_dep_prod_acct_info exchange partition p_${batch_date} with table ${iol_schema}.ifcs_dep_prod_acct_info_cl;
alter table ${iol_schema}.ifcs_dep_prod_acct_info exchange partition p_20991231 with table ${iol_schema}.ifcs_dep_prod_acct_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_dep_prod_acct_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifcs_dep_prod_acct_info_op purge;
drop table ${iol_schema}.ifcs_dep_prod_acct_info_cl purge;
/*
whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifcs_dep_prod_acct_info_bk purge;
*/
-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_dep_prod_acct_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
