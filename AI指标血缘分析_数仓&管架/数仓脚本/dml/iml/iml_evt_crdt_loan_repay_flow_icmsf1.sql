/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_crdt_loan_repay_flow_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_crdt_loan_repay_flow add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_crdt_loan_repay_flow partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_tm purge;
drop table ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_op purge;
drop table ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,dubil_id -- 借据编号
    ,tran_dt -- 交易日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_id -- 证件编号
    ,curr_cd -- 币种代码
    ,deduct_acct_num -- 扣款账户编号
    ,repay_tran_flow_num -- 还款交易流水号
    ,repay_type_cd -- 还款类型代码
    ,rpbl_amt -- 应还金额
    ,actl_repay_amt -- 实际还款金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,surp_pric -- 剩余本金
    ,repay_perds -- 还款期数
    ,revs_flg -- 冲正标志
    ,happ_rs_cd -- 发生原因代码
    ,callbk_id -- 回收编号
    ,core_flow_num -- 核心流水号
    ,chn_id -- 渠道编号
    ,init_sys_id -- 发起系统编号
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_crdt_loan_repay_flow partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_crdt_loan_repay_flow partition for ('icmsf1') where 0=1;

create table ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_crdt_loan_repay_flow partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_bat_repayment-1
insert into ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,dubil_id -- 借据编号
    ,tran_dt -- 交易日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_id -- 证件编号
    ,curr_cd -- 币种代码
    ,deduct_acct_num -- 扣款账户编号
    ,repay_tran_flow_num -- 还款交易流水号
    ,repay_type_cd -- 还款类型代码
    ,rpbl_amt -- 应还金额
    ,actl_repay_amt -- 实际还款金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,surp_pric -- 剩余本金
    ,repay_perds -- 还款期数
    ,revs_flg -- 冲正标志
    ,happ_rs_cd -- 发生原因代码
    ,callbk_id -- 回收编号
    ,core_flow_num -- 核心流水号
    ,chn_id -- 渠道编号
    ,init_sys_id -- 发起系统编号
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101070'||P1.SERIALNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 还款流水号
    ,P1.DUEBILLNO -- 借据编号
    ,P1.TRANSDATE -- 交易日期
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,nvl(trim(P1.CERTTYPE),'0000') -- 证件类型代码
    ,P1.CERTID -- 证件编号
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.PAYACCOUNTNO -- 扣款账户编号
    ,P1.PAYSERIALNO -- 还款交易流水号
    ,nvl(trim(P1.RECEIPTTYPE),'-') -- 还款类型代码
    ,P1.SCHEDULEPAYMENT -- 应还金额
    ,P1.ACTUALPAYMENT -- 实际还款金额
    ,P1.PRIAMT -- 实还本金
    ,P1.INTAMT -- 实还利息
    ,P1.ODPAMT -- 实还罚息
    ,P1.ODIAMT -- 实还复利
    ,P1.REMAMT -- 剩余本金
    ,P1.STAGENO -- 还款期数
    ,decode(P1.REVERSAL,'N','0','Y','1',' ','-',P1.REVERSAL) -- 冲正标志
    ,nvl(trim(P1.REASONCODE),'-') -- 发生原因代码
    ,P1.RECEIPTNO -- 回收编号
    ,P1.TRANSSERIALNO -- 核心流水号
    ,nvl(trim(P1.CHANNEL),'0000') -- 渠道编号
    ,P1.SRCINITSYSID -- 发起系统编号
    ,P1.REMARK -- 备注
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_bat_repayment' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bat_repayment p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                                        ,repay_flow_num
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,dubil_id -- 借据编号
    ,tran_dt -- 交易日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_id -- 证件编号
    ,curr_cd -- 币种代码
    ,deduct_acct_num -- 扣款账户编号
    ,repay_tran_flow_num -- 还款交易流水号
    ,repay_type_cd -- 还款类型代码
    ,rpbl_amt -- 应还金额
    ,actl_repay_amt -- 实际还款金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,surp_pric -- 剩余本金
    ,repay_perds -- 还款期数
    ,revs_flg -- 冲正标志
    ,happ_rs_cd -- 发生原因代码
    ,callbk_id -- 回收编号
    ,core_flow_num -- 核心流水号
    ,chn_id -- 渠道编号
    ,init_sys_id -- 发起系统编号
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,dubil_id -- 借据编号
    ,tran_dt -- 交易日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_id -- 证件编号
    ,curr_cd -- 币种代码
    ,deduct_acct_num -- 扣款账户编号
    ,repay_tran_flow_num -- 还款交易流水号
    ,repay_type_cd -- 还款类型代码
    ,rpbl_amt -- 应还金额
    ,actl_repay_amt -- 实际还款金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,surp_pric -- 剩余本金
    ,repay_perds -- 还款期数
    ,revs_flg -- 冲正标志
    ,happ_rs_cd -- 发生原因代码
    ,callbk_id -- 回收编号
    ,core_flow_num -- 核心流水号
    ,chn_id -- 渠道编号
    ,init_sys_id -- 发起系统编号
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.repay_flow_num, o.repay_flow_num) as repay_flow_num -- 还款流水号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_id, o.cert_id) as cert_id -- 证件编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.deduct_acct_num, o.deduct_acct_num) as deduct_acct_num -- 扣款账户编号
    ,nvl(n.repay_tran_flow_num, o.repay_tran_flow_num) as repay_tran_flow_num -- 还款交易流水号
    ,nvl(n.repay_type_cd, o.repay_type_cd) as repay_type_cd -- 还款类型代码
    ,nvl(n.rpbl_amt, o.rpbl_amt) as rpbl_amt -- 应还金额
    ,nvl(n.actl_repay_amt, o.actl_repay_amt) as actl_repay_amt -- 实际还款金额
    ,nvl(n.paid_pric, o.paid_pric) as paid_pric -- 实还本金
    ,nvl(n.paid_int, o.paid_int) as paid_int -- 实还利息
    ,nvl(n.paid_pnlt, o.paid_pnlt) as paid_pnlt -- 实还罚息
    ,nvl(n.paid_comp_int, o.paid_comp_int) as paid_comp_int -- 实还复利
    ,nvl(n.surp_pric, o.surp_pric) as surp_pric -- 剩余本金
    ,nvl(n.repay_perds, o.repay_perds) as repay_perds -- 还款期数
    ,nvl(n.revs_flg, o.revs_flg) as revs_flg -- 冲正标志
    ,nvl(n.happ_rs_cd, o.happ_rs_cd) as happ_rs_cd -- 发生原因代码
    ,nvl(n.callbk_id, o.callbk_id) as callbk_id -- 回收编号
    ,nvl(n.core_flow_num, o.core_flow_num) as core_flow_num -- 核心流水号
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.init_sys_id, o.init_sys_id) as init_sys_id -- 发起系统编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.final_update_teller_id, o.final_update_teller_id) as final_update_teller_id -- 最后更新柜员编号
    ,nvl(n.final_update_org_id, o.final_update_org_id) as final_update_org_id -- 最后更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.repay_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.repay_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.repay_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_tm n
    full join (select * from ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.repay_flow_num = n.repay_flow_num
where (
        o.evt_id is null
        and o.lp_id is null
        and o.repay_flow_num is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
        and n.repay_flow_num is null
    )
    or (
        o.dubil_id <> n.dubil_id
        or o.tran_dt <> n.tran_dt
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_id <> n.cert_id
        or o.curr_cd <> n.curr_cd
        or o.deduct_acct_num <> n.deduct_acct_num
        or o.repay_tran_flow_num <> n.repay_tran_flow_num
        or o.repay_type_cd <> n.repay_type_cd
        or o.rpbl_amt <> n.rpbl_amt
        or o.actl_repay_amt <> n.actl_repay_amt
        or o.paid_pric <> n.paid_pric
        or o.paid_int <> n.paid_int
        or o.paid_pnlt <> n.paid_pnlt
        or o.paid_comp_int <> n.paid_comp_int
        or o.surp_pric <> n.surp_pric
        or o.repay_perds <> n.repay_perds
        or o.revs_flg <> n.revs_flg
        or o.happ_rs_cd <> n.happ_rs_cd
        or o.callbk_id <> n.callbk_id
        or o.core_flow_num <> n.core_flow_num
        or o.chn_id <> n.chn_id
        or o.init_sys_id <> n.init_sys_id
        or o.remark <> n.remark
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.final_update_teller_id <> n.final_update_teller_id
        or o.final_update_org_id <> n.final_update_org_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,dubil_id -- 借据编号
    ,tran_dt -- 交易日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_id -- 证件编号
    ,curr_cd -- 币种代码
    ,deduct_acct_num -- 扣款账户编号
    ,repay_tran_flow_num -- 还款交易流水号
    ,repay_type_cd -- 还款类型代码
    ,rpbl_amt -- 应还金额
    ,actl_repay_amt -- 实际还款金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,surp_pric -- 剩余本金
    ,repay_perds -- 还款期数
    ,revs_flg -- 冲正标志
    ,happ_rs_cd -- 发生原因代码
    ,callbk_id -- 回收编号
    ,core_flow_num -- 核心流水号
    ,chn_id -- 渠道编号
    ,init_sys_id -- 发起系统编号
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,dubil_id -- 借据编号
    ,tran_dt -- 交易日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_id -- 证件编号
    ,curr_cd -- 币种代码
    ,deduct_acct_num -- 扣款账户编号
    ,repay_tran_flow_num -- 还款交易流水号
    ,repay_type_cd -- 还款类型代码
    ,rpbl_amt -- 应还金额
    ,actl_repay_amt -- 实际还款金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,surp_pric -- 剩余本金
    ,repay_perds -- 还款期数
    ,revs_flg -- 冲正标志
    ,happ_rs_cd -- 发生原因代码
    ,callbk_id -- 回收编号
    ,core_flow_num -- 核心流水号
    ,chn_id -- 渠道编号
    ,init_sys_id -- 发起系统编号
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.repay_flow_num -- 还款流水号
    ,o.dubil_id -- 借据编号
    ,o.tran_dt -- 交易日期
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_id -- 证件编号
    ,o.curr_cd -- 币种代码
    ,o.deduct_acct_num -- 扣款账户编号
    ,o.repay_tran_flow_num -- 还款交易流水号
    ,o.repay_type_cd -- 还款类型代码
    ,o.rpbl_amt -- 应还金额
    ,o.actl_repay_amt -- 实际还款金额
    ,o.paid_pric -- 实还本金
    ,o.paid_int -- 实还利息
    ,o.paid_pnlt -- 实还罚息
    ,o.paid_comp_int -- 实还复利
    ,o.surp_pric -- 剩余本金
    ,o.repay_perds -- 还款期数
    ,o.revs_flg -- 冲正标志
    ,o.happ_rs_cd -- 发生原因代码
    ,o.callbk_id -- 回收编号
    ,o.core_flow_num -- 核心流水号
    ,o.chn_id -- 渠道编号
    ,o.init_sys_id -- 发起系统编号
    ,o.remark -- 备注
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.final_update_teller_id -- 最后更新柜员编号
    ,o.final_update_org_id -- 最后更新机构编号
    ,o.final_update_dt -- 最后更新日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_bk o
    left join ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.repay_flow_num = n.repay_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
            and o.repay_flow_num = d.repay_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_crdt_loan_repay_flow;
--alter table ${iml_schema}.evt_crdt_loan_repay_flow truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_crdt_loan_repay_flow') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_crdt_loan_repay_flow drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_crdt_loan_repay_flow modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_crdt_loan_repay_flow exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_cl;
alter table ${iml_schema}.evt_crdt_loan_repay_flow exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_crdt_loan_repay_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_tm purge;
drop table ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_op purge;
drop table ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_crdt_loan_repay_flow_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_crdt_loan_repay_flow', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
