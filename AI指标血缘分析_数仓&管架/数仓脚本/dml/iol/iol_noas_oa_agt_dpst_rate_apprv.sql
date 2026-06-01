/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_noas_oa_agt_dpst_rate_apprv
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
create table ${iol_schema}.noas_oa_agt_dpst_rate_apprv_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.noas_oa_agt_dpst_rate_apprv;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_agt_dpst_rate_apprv_op purge;
drop table ${iol_schema}.noas_oa_agt_dpst_rate_apprv_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_agt_dpst_rate_apprv_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_agt_dpst_rate_apprv where 0=1;

create table ${iol_schema}.noas_oa_agt_dpst_rate_apprv_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_agt_dpst_rate_apprv where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_agt_dpst_rate_apprv_cl(
            agt_dpst_rate_apprv_id -- 主键
            ,data_src_cd -- 数据来源代码
            ,del_flg -- 删除标志:1-是，0:否
            ,etl_dt_ora -- 数据日期
            ,aprv_id -- 审批编号
            ,apprv_typ_cd -- 审批类型代码
            ,aprv_status_cd -- 审批状态代码
            ,app_categ_cd -- 申请类别代码
            ,app_rate_acct -- 申请利率账号
            ,new_acct_flg -- 新增账号标志
            ,ccy_cd -- 币种代码
            ,new_agt_flg -- 新增协议标志
            ,ori_apprv_id -- 原审批编号
            ,pty_id -- 客户编号
            ,pty_name -- 客户名称
            ,crdt_pty_flg -- 授信客户标志
            ,crdt_pty_syn_income_situ -- 授信客户综合收益情况
            ,dpst_breed_cd -- 储种代码
            ,peri_typ_cd -- 存期类型代码
            ,agt_status_cd -- 协议状态代码
            ,contr_due_dt -- 协议到期日期
            ,apprv_start_dt -- 审批开始日期
            ,apprv_end_dt -- 审批结束日期
            ,apprv_due_dt -- 审批到期日期
            ,blng_org_id -- 所属机构编号
            ,app_emp_id -- 申请员工编号
            ,final_aprv_emp_id -- 最终审批人员工编号
            ,dpst_prd_acct_id -- 存款产品户编号
            ,app_reas_situ_intro -- 申请理由及情况介绍
            ,process_ins_id -- 流程id
            ,last_updated_stamp -- 最后修改时间
            ,last_updated_tx_stamp -- 最后修改时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建时间
            ,app_amt_ceil -- 申请金额上限
            ,base_rate_val -- 基准利率值
            ,rate_float_val -- 利率浮动值
            ,exec_rate -- 执行利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_agt_dpst_rate_apprv_op(
            agt_dpst_rate_apprv_id -- 主键
            ,data_src_cd -- 数据来源代码
            ,del_flg -- 删除标志:1-是，0:否
            ,etl_dt_ora -- 数据日期
            ,aprv_id -- 审批编号
            ,apprv_typ_cd -- 审批类型代码
            ,aprv_status_cd -- 审批状态代码
            ,app_categ_cd -- 申请类别代码
            ,app_rate_acct -- 申请利率账号
            ,new_acct_flg -- 新增账号标志
            ,ccy_cd -- 币种代码
            ,new_agt_flg -- 新增协议标志
            ,ori_apprv_id -- 原审批编号
            ,pty_id -- 客户编号
            ,pty_name -- 客户名称
            ,crdt_pty_flg -- 授信客户标志
            ,crdt_pty_syn_income_situ -- 授信客户综合收益情况
            ,dpst_breed_cd -- 储种代码
            ,peri_typ_cd -- 存期类型代码
            ,agt_status_cd -- 协议状态代码
            ,contr_due_dt -- 协议到期日期
            ,apprv_start_dt -- 审批开始日期
            ,apprv_end_dt -- 审批结束日期
            ,apprv_due_dt -- 审批到期日期
            ,blng_org_id -- 所属机构编号
            ,app_emp_id -- 申请员工编号
            ,final_aprv_emp_id -- 最终审批人员工编号
            ,dpst_prd_acct_id -- 存款产品户编号
            ,app_reas_situ_intro -- 申请理由及情况介绍
            ,process_ins_id -- 流程id
            ,last_updated_stamp -- 最后修改时间
            ,last_updated_tx_stamp -- 最后修改时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建时间
            ,app_amt_ceil -- 申请金额上限
            ,base_rate_val -- 基准利率值
            ,rate_float_val -- 利率浮动值
            ,exec_rate -- 执行利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_dpst_rate_apprv_id, o.agt_dpst_rate_apprv_id) as agt_dpst_rate_apprv_id -- 主键
    ,nvl(n.data_src_cd, o.data_src_cd) as data_src_cd -- 数据来源代码
    ,nvl(n.del_flg, o.del_flg) as del_flg -- 删除标志:1-是，0:否
    ,nvl(n.etl_dt_ora, o.etl_dt_ora) as etl_dt_ora -- 数据日期
    ,nvl(n.aprv_id, o.aprv_id) as aprv_id -- 审批编号
    ,nvl(n.apprv_typ_cd, o.apprv_typ_cd) as apprv_typ_cd -- 审批类型代码
    ,nvl(n.aprv_status_cd, o.aprv_status_cd) as aprv_status_cd -- 审批状态代码
    ,nvl(n.app_categ_cd, o.app_categ_cd) as app_categ_cd -- 申请类别代码
    ,nvl(n.app_rate_acct, o.app_rate_acct) as app_rate_acct -- 申请利率账号
    ,nvl(n.new_acct_flg, o.new_acct_flg) as new_acct_flg -- 新增账号标志
    ,nvl(n.ccy_cd, o.ccy_cd) as ccy_cd -- 币种代码
    ,nvl(n.new_agt_flg, o.new_agt_flg) as new_agt_flg -- 新增协议标志
    ,nvl(n.ori_apprv_id, o.ori_apprv_id) as ori_apprv_id -- 原审批编号
    ,nvl(n.pty_id, o.pty_id) as pty_id -- 客户编号
    ,nvl(n.pty_name, o.pty_name) as pty_name -- 客户名称
    ,nvl(n.crdt_pty_flg, o.crdt_pty_flg) as crdt_pty_flg -- 授信客户标志
    ,nvl(n.crdt_pty_syn_income_situ, o.crdt_pty_syn_income_situ) as crdt_pty_syn_income_situ -- 授信客户综合收益情况
    ,nvl(n.dpst_breed_cd, o.dpst_breed_cd) as dpst_breed_cd -- 储种代码
    ,nvl(n.peri_typ_cd, o.peri_typ_cd) as peri_typ_cd -- 存期类型代码
    ,nvl(n.agt_status_cd, o.agt_status_cd) as agt_status_cd -- 协议状态代码
    ,nvl(n.contr_due_dt, o.contr_due_dt) as contr_due_dt -- 协议到期日期
    ,nvl(n.apprv_start_dt, o.apprv_start_dt) as apprv_start_dt -- 审批开始日期
    ,nvl(n.apprv_end_dt, o.apprv_end_dt) as apprv_end_dt -- 审批结束日期
    ,nvl(n.apprv_due_dt, o.apprv_due_dt) as apprv_due_dt -- 审批到期日期
    ,nvl(n.blng_org_id, o.blng_org_id) as blng_org_id -- 所属机构编号
    ,nvl(n.app_emp_id, o.app_emp_id) as app_emp_id -- 申请员工编号
    ,nvl(n.final_aprv_emp_id, o.final_aprv_emp_id) as final_aprv_emp_id -- 最终审批人员工编号
    ,nvl(n.dpst_prd_acct_id, o.dpst_prd_acct_id) as dpst_prd_acct_id -- 存款产品户编号
    ,nvl(n.app_reas_situ_intro, o.app_reas_situ_intro) as app_reas_situ_intro -- 申请理由及情况介绍
    ,nvl(n.process_ins_id, o.process_ins_id) as process_ins_id -- 流程id
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 最后修改时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 最后修改时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 创建时间
    ,nvl(n.app_amt_ceil, o.app_amt_ceil) as app_amt_ceil -- 申请金额上限
    ,nvl(n.base_rate_val, o.base_rate_val) as base_rate_val -- 基准利率值
    ,nvl(n.rate_float_val, o.rate_float_val) as rate_float_val -- 利率浮动值
    ,nvl(n.exec_rate, o.exec_rate) as exec_rate -- 执行利率
    ,case when
            n.agt_dpst_rate_apprv_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_dpst_rate_apprv_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_dpst_rate_apprv_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.noas_oa_agt_dpst_rate_apprv_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.noas_oa_agt_dpst_rate_apprv where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agt_dpst_rate_apprv_id = n.agt_dpst_rate_apprv_id
where (
        o.agt_dpst_rate_apprv_id is null
    )
    or (
        n.agt_dpst_rate_apprv_id is null
    )
    or (
        o.data_src_cd <> n.data_src_cd
        or o.del_flg <> n.del_flg
        or o.etl_dt_ora <> n.etl_dt_ora
        or o.aprv_id <> n.aprv_id
        or o.apprv_typ_cd <> n.apprv_typ_cd
        or o.aprv_status_cd <> n.aprv_status_cd
        or o.app_categ_cd <> n.app_categ_cd
        or o.app_rate_acct <> n.app_rate_acct
        or o.new_acct_flg <> n.new_acct_flg
        or o.ccy_cd <> n.ccy_cd
        or o.new_agt_flg <> n.new_agt_flg
        or o.ori_apprv_id <> n.ori_apprv_id
        or o.pty_id <> n.pty_id
        or o.pty_name <> n.pty_name
        or o.crdt_pty_flg <> n.crdt_pty_flg
        or o.crdt_pty_syn_income_situ <> n.crdt_pty_syn_income_situ
        or o.dpst_breed_cd <> n.dpst_breed_cd
        or o.peri_typ_cd <> n.peri_typ_cd
        or o.agt_status_cd <> n.agt_status_cd
        or o.contr_due_dt <> n.contr_due_dt
        or o.apprv_start_dt <> n.apprv_start_dt
        or o.apprv_end_dt <> n.apprv_end_dt
        or o.apprv_due_dt <> n.apprv_due_dt
        or o.blng_org_id <> n.blng_org_id
        or o.app_emp_id <> n.app_emp_id
        or o.final_aprv_emp_id <> n.final_aprv_emp_id
        or o.dpst_prd_acct_id <> n.dpst_prd_acct_id
        or o.app_reas_situ_intro <> n.app_reas_situ_intro
        or o.process_ins_id <> n.process_ins_id
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.app_amt_ceil <> n.app_amt_ceil
        or o.base_rate_val <> n.base_rate_val
        or o.rate_float_val <> n.rate_float_val
        or o.exec_rate <> n.exec_rate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_agt_dpst_rate_apprv_cl(
            agt_dpst_rate_apprv_id -- 主键
            ,data_src_cd -- 数据来源代码
            ,del_flg -- 删除标志:1-是，0:否
            ,etl_dt_ora -- 数据日期
            ,aprv_id -- 审批编号
            ,apprv_typ_cd -- 审批类型代码
            ,aprv_status_cd -- 审批状态代码
            ,app_categ_cd -- 申请类别代码
            ,app_rate_acct -- 申请利率账号
            ,new_acct_flg -- 新增账号标志
            ,ccy_cd -- 币种代码
            ,new_agt_flg -- 新增协议标志
            ,ori_apprv_id -- 原审批编号
            ,pty_id -- 客户编号
            ,pty_name -- 客户名称
            ,crdt_pty_flg -- 授信客户标志
            ,crdt_pty_syn_income_situ -- 授信客户综合收益情况
            ,dpst_breed_cd -- 储种代码
            ,peri_typ_cd -- 存期类型代码
            ,agt_status_cd -- 协议状态代码
            ,contr_due_dt -- 协议到期日期
            ,apprv_start_dt -- 审批开始日期
            ,apprv_end_dt -- 审批结束日期
            ,apprv_due_dt -- 审批到期日期
            ,blng_org_id -- 所属机构编号
            ,app_emp_id -- 申请员工编号
            ,final_aprv_emp_id -- 最终审批人员工编号
            ,dpst_prd_acct_id -- 存款产品户编号
            ,app_reas_situ_intro -- 申请理由及情况介绍
            ,process_ins_id -- 流程id
            ,last_updated_stamp -- 最后修改时间
            ,last_updated_tx_stamp -- 最后修改时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建时间
            ,app_amt_ceil -- 申请金额上限
            ,base_rate_val -- 基准利率值
            ,rate_float_val -- 利率浮动值
            ,exec_rate -- 执行利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_agt_dpst_rate_apprv_op(
            agt_dpst_rate_apprv_id -- 主键
            ,data_src_cd -- 数据来源代码
            ,del_flg -- 删除标志:1-是，0:否
            ,etl_dt_ora -- 数据日期
            ,aprv_id -- 审批编号
            ,apprv_typ_cd -- 审批类型代码
            ,aprv_status_cd -- 审批状态代码
            ,app_categ_cd -- 申请类别代码
            ,app_rate_acct -- 申请利率账号
            ,new_acct_flg -- 新增账号标志
            ,ccy_cd -- 币种代码
            ,new_agt_flg -- 新增协议标志
            ,ori_apprv_id -- 原审批编号
            ,pty_id -- 客户编号
            ,pty_name -- 客户名称
            ,crdt_pty_flg -- 授信客户标志
            ,crdt_pty_syn_income_situ -- 授信客户综合收益情况
            ,dpst_breed_cd -- 储种代码
            ,peri_typ_cd -- 存期类型代码
            ,agt_status_cd -- 协议状态代码
            ,contr_due_dt -- 协议到期日期
            ,apprv_start_dt -- 审批开始日期
            ,apprv_end_dt -- 审批结束日期
            ,apprv_due_dt -- 审批到期日期
            ,blng_org_id -- 所属机构编号
            ,app_emp_id -- 申请员工编号
            ,final_aprv_emp_id -- 最终审批人员工编号
            ,dpst_prd_acct_id -- 存款产品户编号
            ,app_reas_situ_intro -- 申请理由及情况介绍
            ,process_ins_id -- 流程id
            ,last_updated_stamp -- 最后修改时间
            ,last_updated_tx_stamp -- 最后修改时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建时间
            ,app_amt_ceil -- 申请金额上限
            ,base_rate_val -- 基准利率值
            ,rate_float_val -- 利率浮动值
            ,exec_rate -- 执行利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_dpst_rate_apprv_id -- 主键
    ,o.data_src_cd -- 数据来源代码
    ,o.del_flg -- 删除标志:1-是，0:否
    ,o.etl_dt_ora -- 数据日期
    ,o.aprv_id -- 审批编号
    ,o.apprv_typ_cd -- 审批类型代码
    ,o.aprv_status_cd -- 审批状态代码
    ,o.app_categ_cd -- 申请类别代码
    ,o.app_rate_acct -- 申请利率账号
    ,o.new_acct_flg -- 新增账号标志
    ,o.ccy_cd -- 币种代码
    ,o.new_agt_flg -- 新增协议标志
    ,o.ori_apprv_id -- 原审批编号
    ,o.pty_id -- 客户编号
    ,o.pty_name -- 客户名称
    ,o.crdt_pty_flg -- 授信客户标志
    ,o.crdt_pty_syn_income_situ -- 授信客户综合收益情况
    ,o.dpst_breed_cd -- 储种代码
    ,o.peri_typ_cd -- 存期类型代码
    ,o.agt_status_cd -- 协议状态代码
    ,o.contr_due_dt -- 协议到期日期
    ,o.apprv_start_dt -- 审批开始日期
    ,o.apprv_end_dt -- 审批结束日期
    ,o.apprv_due_dt -- 审批到期日期
    ,o.blng_org_id -- 所属机构编号
    ,o.app_emp_id -- 申请员工编号
    ,o.final_aprv_emp_id -- 最终审批人员工编号
    ,o.dpst_prd_acct_id -- 存款产品户编号
    ,o.app_reas_situ_intro -- 申请理由及情况介绍
    ,o.process_ins_id -- 流程id
    ,o.last_updated_stamp -- 最后修改时间
    ,o.last_updated_tx_stamp -- 最后修改时间
    ,o.created_stamp -- 创建时间
    ,o.created_tx_stamp -- 创建时间
    ,o.app_amt_ceil -- 申请金额上限
    ,o.base_rate_val -- 基准利率值
    ,o.rate_float_val -- 利率浮动值
    ,o.exec_rate -- 执行利率
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.noas_oa_agt_dpst_rate_apprv_bk o
    left join ${iol_schema}.noas_oa_agt_dpst_rate_apprv_op n
        on
            o.agt_dpst_rate_apprv_id = n.agt_dpst_rate_apprv_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.noas_oa_agt_dpst_rate_apprv_cl d
        on
            o.agt_dpst_rate_apprv_id = d.agt_dpst_rate_apprv_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.noas_oa_agt_dpst_rate_apprv;

-- 4.2 exchange partition
alter table ${iol_schema}.noas_oa_agt_dpst_rate_apprv exchange partition p_19000101 with table ${iol_schema}.noas_oa_agt_dpst_rate_apprv_cl;
alter table ${iol_schema}.noas_oa_agt_dpst_rate_apprv exchange partition p_20991231 with table ${iol_schema}.noas_oa_agt_dpst_rate_apprv_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.noas_oa_agt_dpst_rate_apprv to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_agt_dpst_rate_apprv_op purge;
drop table ${iol_schema}.noas_oa_agt_dpst_rate_apprv_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.noas_oa_agt_dpst_rate_apprv_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'noas_oa_agt_dpst_rate_apprv',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
