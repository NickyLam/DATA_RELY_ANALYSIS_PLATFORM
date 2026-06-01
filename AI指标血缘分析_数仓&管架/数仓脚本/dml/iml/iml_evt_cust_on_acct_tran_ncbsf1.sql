/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_cust_on_acct_tran_ncbsf1
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
alter table ${iml_schema}.evt_cust_on_acct_tran add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_cust_on_acct_tran partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_tm purge;
drop table ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_op purge;
drop table ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_sub_acct_num -- 挂账子账号
    ,curr_cd -- 币种代码
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,appl_cust_id -- 申请客户编号
    ,debit_crdt_flg -- 借贷标志
    ,on_acct_tot -- 挂账总额
    ,on_acct_amt -- 挂账金额
    ,on_acct_bal -- 挂账余额
    ,on_acct_exp_dt -- 挂账到期日期
    ,cap_src_cd -- 资金来源代码
    ,tran_ref_no -- 交易参考号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_status_cd -- 交易状态代码
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,cntpty_acct_bank_int_flg -- 交易对手账户行内标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_memo_descb -- 交易摘要描述
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_id -- 结算账户编号
    ,gold_bus_id -- 押金业务编号
    ,auth_teller_id -- 授权柜员编号
    ,last_modif_dt -- 上次修改日期
    ,final_modif_dt -- 最后修改日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cust_on_acct_tran partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_cust_on_acct_tran partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_cust_on_acct_tran partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_gl_hang_account-1
insert into ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_sub_acct_num -- 挂账子账号
    ,curr_cd -- 币种代码
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,appl_cust_id -- 申请客户编号
    ,debit_crdt_flg -- 借贷标志
    ,on_acct_tot -- 挂账总额
    ,on_acct_amt -- 挂账金额
    ,on_acct_bal -- 挂账余额
    ,on_acct_exp_dt -- 挂账到期日期
    ,cap_src_cd -- 资金来源代码
    ,tran_ref_no -- 交易参考号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_status_cd -- 交易状态代码
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,cntpty_acct_bank_int_flg -- 交易对手账户行内标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_memo_descb -- 交易摘要描述
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_id -- 结算账户编号
    ,gold_bus_id -- 押金业务编号
    ,auth_teller_id -- 授权柜员编号
    ,last_modif_dt -- 上次修改日期
    ,final_modif_dt -- 最后修改日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101041'||P1.CLIENT_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.HANG_SEQ_NO -- 挂账序号
    ,P1.SUB_HANG_SEQ_NO -- 挂账子账号
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,P1.BASE_ACCT_NO -- 客户账号
    ,case when r1.target_cd_val is not null then r1.target_cd_val else '@'||P1.CLIENT_TYPE end -- 客户类型代码
    ,P1.CLIENT_NO -- 客户编号
    ,P1.CLIENT_NAME -- 客户名称
    ,P1.DOCUMENT_ID -- 证件号码
    ,nvl(trim(P1.DOCUMENT_TYPE),'0000') -- 证件类型代码
    ,P1.APPLY_CLIENT_NO -- 申请客户编号
    ,nvl(trim(P1.CR_DR_IND),'-') -- 借贷标志
    ,P1.HANG_TOTAL_AMT -- 挂账总额
    ,P1.HANG_AMT -- 挂账金额
    ,P1.HANG_BAL -- 挂账余额
    ,P1.HANG_END_DATE -- 挂账到期日期
    ,nvl(trim(P1.HANG_DEAL_TYPE),'-') -- 资金来源代码
    ,P1.REFERENCE -- 交易参考号
    ,iml.dateformat_max2(to_char(P1.TRAN_DATE,'yyyymmdd')||P1.HANG_WRITE_OFF_TIME) -- 交易日期
    ,${iml_schema}.timeformat_max(P1.TRAN_TIMESTAMP) -- 交易时间
    ,nvl(trim(P1.HANG_STATUS),'-') -- 交易状态代码
    ,P1.OTH_ACCT_NAME -- 交易对手账户名称
    ,P1.OTH_BASE_ACCT_NO -- 交易对手账户编号
    ,P1.OTH_BRANCH -- 交易对手开户机构编号
    ,decode(P1.OTH_BANK_FLAG,' ','-','Y','1','N','0',P1.OTH_BANK_FLAG) -- 交易对手账户行内标志
    ,P1.USER_ID -- 交易柜员编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.NARRATIVE -- 交易摘要描述
    ,P1.SETTLE_ACCT_NAME -- 结算账户名称
    ,P1.SETTLE_BASE_ACCT_NO -- 结算账户编号
    ,P1.PLEDGE_BUSI_NO -- 押金业务编号
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,iml.dateformat_max2(P1.LAST_CHANGE_TIME) -- 上次修改日期
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_gl_hang_account' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.ncbs_rb_gl_hang_account p1
  left join iml.ref_pub_cd_map r1
    on p1.client_type = r1.src_code_val
   and r1.sorc_sys_cd = 'NCBS'
   and r1.src_tab_en_name = 'NCBS_RB_GL_HANG_ACCOUNT'
   and r1.src_field_en_name = 'CLIENT_TYPE'
   and r1.target_tab_en_name = 'EVT_CUST_ON_ACCT_TRAN'
   and r1.target_tab_field_en_name = 'CUST_TYPE_CD'
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   ;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                                        ,on_acct_seq_num
  	                                        ,on_acct_sub_acct_num
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
        into ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_sub_acct_num -- 挂账子账号
    ,curr_cd -- 币种代码
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,appl_cust_id -- 申请客户编号
    ,debit_crdt_flg -- 借贷标志
    ,on_acct_tot -- 挂账总额
    ,on_acct_amt -- 挂账金额
    ,on_acct_bal -- 挂账余额
    ,on_acct_exp_dt -- 挂账到期日期
    ,cap_src_cd -- 资金来源代码
    ,tran_ref_no -- 交易参考号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_status_cd -- 交易状态代码
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,cntpty_acct_bank_int_flg -- 交易对手账户行内标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_memo_descb -- 交易摘要描述
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_id -- 结算账户编号
    ,gold_bus_id -- 押金业务编号
    ,auth_teller_id -- 授权柜员编号
    ,last_modif_dt -- 上次修改日期
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_sub_acct_num -- 挂账子账号
    ,curr_cd -- 币种代码
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,appl_cust_id -- 申请客户编号
    ,debit_crdt_flg -- 借贷标志
    ,on_acct_tot -- 挂账总额
    ,on_acct_amt -- 挂账金额
    ,on_acct_bal -- 挂账余额
    ,on_acct_exp_dt -- 挂账到期日期
    ,cap_src_cd -- 资金来源代码
    ,tran_ref_no -- 交易参考号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_status_cd -- 交易状态代码
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,cntpty_acct_bank_int_flg -- 交易对手账户行内标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_memo_descb -- 交易摘要描述
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_id -- 结算账户编号
    ,gold_bus_id -- 押金业务编号
    ,auth_teller_id -- 授权柜员编号
    ,last_modif_dt -- 上次修改日期
    ,final_modif_dt -- 最后修改日期
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
    ,nvl(n.on_acct_seq_num, o.on_acct_seq_num) as on_acct_seq_num -- 挂账序号
    ,nvl(n.on_acct_sub_acct_num, o.on_acct_sub_acct_num) as on_acct_sub_acct_num -- 挂账子账号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.appl_cust_id, o.appl_cust_id) as appl_cust_id -- 申请客户编号
    ,nvl(n.debit_crdt_flg, o.debit_crdt_flg) as debit_crdt_flg -- 借贷标志
    ,nvl(n.on_acct_tot, o.on_acct_tot) as on_acct_tot -- 挂账总额
    ,nvl(n.on_acct_amt, o.on_acct_amt) as on_acct_amt -- 挂账金额
    ,nvl(n.on_acct_bal, o.on_acct_bal) as on_acct_bal -- 挂账余额
    ,nvl(n.on_acct_exp_dt, o.on_acct_exp_dt) as on_acct_exp_dt -- 挂账到期日期
    ,nvl(n.cap_src_cd, o.cap_src_cd) as cap_src_cd -- 资金来源代码
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.cntpty_acct_name, o.cntpty_acct_name) as cntpty_acct_name -- 交易对手账户名称
    ,nvl(n.cntpty_acct_id, o.cntpty_acct_id) as cntpty_acct_id -- 交易对手账户编号
    ,nvl(n.cntpty_open_acct_org_id, o.cntpty_open_acct_org_id) as cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,nvl(n.cntpty_acct_bank_int_flg, o.cntpty_acct_bank_int_flg) as cntpty_acct_bank_int_flg -- 交易对手账户行内标志
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.tran_memo_descb, o.tran_memo_descb) as tran_memo_descb -- 交易摘要描述
    ,nvl(n.stl_acct_name, o.stl_acct_name) as stl_acct_name -- 结算账户名称
    ,nvl(n.stl_acct_id, o.stl_acct_id) as stl_acct_id -- 结算账户编号
    ,nvl(n.gold_bus_id, o.gold_bus_id) as gold_bus_id -- 押金业务编号
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.last_modif_dt, o.last_modif_dt) as last_modif_dt -- 上次修改日期
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.on_acct_seq_num is null
            and n.on_acct_sub_acct_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.on_acct_seq_num is null
            and n.on_acct_sub_acct_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.on_acct_seq_num is null
            and n.on_acct_sub_acct_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_tm n
    full join (select * from ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.on_acct_seq_num = n.on_acct_seq_num
            and o.on_acct_sub_acct_num = n.on_acct_sub_acct_num
where (
        o.evt_id is null
        and o.lp_id is null
        and o.on_acct_seq_num is null
        and o.on_acct_sub_acct_num is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
        and n.on_acct_seq_num is null
        and n.on_acct_sub_acct_num is null
    )
    or (
        o.curr_cd <> n.curr_cd
        or o.cust_acct_num <> n.cust_acct_num
        or o.cust_type_cd <> n.cust_type_cd
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cert_no <> n.cert_no
        or o.cert_type_cd <> n.cert_type_cd
        or o.appl_cust_id <> n.appl_cust_id
        or o.debit_crdt_flg <> n.debit_crdt_flg
        or o.on_acct_tot <> n.on_acct_tot
        or o.on_acct_amt <> n.on_acct_amt
        or o.on_acct_bal <> n.on_acct_bal
        or o.on_acct_exp_dt <> n.on_acct_exp_dt
        or o.cap_src_cd <> n.cap_src_cd
        or o.tran_ref_no <> n.tran_ref_no
        or o.tran_dt <> n.tran_dt
        or o.tran_tm <> n.tran_tm
        or o.tran_status_cd <> n.tran_status_cd
        or o.cntpty_acct_name <> n.cntpty_acct_name
        or o.cntpty_acct_id <> n.cntpty_acct_id
        or o.cntpty_open_acct_org_id <> n.cntpty_open_acct_org_id
        or o.cntpty_acct_bank_int_flg <> n.cntpty_acct_bank_int_flg
        or o.tran_teller_id <> n.tran_teller_id
        or o.tran_org_id <> n.tran_org_id
        or o.tran_memo_descb <> n.tran_memo_descb
        or o.stl_acct_name <> n.stl_acct_name
        or o.stl_acct_id <> n.stl_acct_id
        or o.gold_bus_id <> n.gold_bus_id
        or o.auth_teller_id <> n.auth_teller_id
        or o.last_modif_dt <> n.last_modif_dt
        or o.final_modif_dt <> n.final_modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_sub_acct_num -- 挂账子账号
    ,curr_cd -- 币种代码
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,appl_cust_id -- 申请客户编号
    ,debit_crdt_flg -- 借贷标志
    ,on_acct_tot -- 挂账总额
    ,on_acct_amt -- 挂账金额
    ,on_acct_bal -- 挂账余额
    ,on_acct_exp_dt -- 挂账到期日期
    ,cap_src_cd -- 资金来源代码
    ,tran_ref_no -- 交易参考号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_status_cd -- 交易状态代码
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,cntpty_acct_bank_int_flg -- 交易对手账户行内标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_memo_descb -- 交易摘要描述
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_id -- 结算账户编号
    ,gold_bus_id -- 押金业务编号
    ,auth_teller_id -- 授权柜员编号
    ,last_modif_dt -- 上次修改日期
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_sub_acct_num -- 挂账子账号
    ,curr_cd -- 币种代码
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,appl_cust_id -- 申请客户编号
    ,debit_crdt_flg -- 借贷标志
    ,on_acct_tot -- 挂账总额
    ,on_acct_amt -- 挂账金额
    ,on_acct_bal -- 挂账余额
    ,on_acct_exp_dt -- 挂账到期日期
    ,cap_src_cd -- 资金来源代码
    ,tran_ref_no -- 交易参考号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_status_cd -- 交易状态代码
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,cntpty_acct_bank_int_flg -- 交易对手账户行内标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_memo_descb -- 交易摘要描述
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_id -- 结算账户编号
    ,gold_bus_id -- 押金业务编号
    ,auth_teller_id -- 授权柜员编号
    ,last_modif_dt -- 上次修改日期
    ,final_modif_dt -- 最后修改日期
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
    ,o.on_acct_seq_num -- 挂账序号
    ,o.on_acct_sub_acct_num -- 挂账子账号
    ,o.curr_cd -- 币种代码
    ,o.cust_acct_num -- 客户账号
    ,o.cust_type_cd -- 客户类型代码
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.cert_no -- 证件号码
    ,o.cert_type_cd -- 证件类型代码
    ,o.appl_cust_id -- 申请客户编号
    ,o.debit_crdt_flg -- 借贷标志
    ,o.on_acct_tot -- 挂账总额
    ,o.on_acct_amt -- 挂账金额
    ,o.on_acct_bal -- 挂账余额
    ,o.on_acct_exp_dt -- 挂账到期日期
    ,o.cap_src_cd -- 资金来源代码
    ,o.tran_ref_no -- 交易参考号
    ,o.tran_dt -- 交易日期
    ,o.tran_tm -- 交易时间
    ,o.tran_status_cd -- 交易状态代码
    ,o.cntpty_acct_name -- 交易对手账户名称
    ,o.cntpty_acct_id -- 交易对手账户编号
    ,o.cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,o.cntpty_acct_bank_int_flg -- 交易对手账户行内标志
    ,o.tran_teller_id -- 交易柜员编号
    ,o.tran_org_id -- 交易机构编号
    ,o.tran_memo_descb -- 交易摘要描述
    ,o.stl_acct_name -- 结算账户名称
    ,o.stl_acct_id -- 结算账户编号
    ,o.gold_bus_id -- 押金业务编号
    ,o.auth_teller_id -- 授权柜员编号
    ,o.last_modif_dt -- 上次修改日期
    ,o.final_modif_dt -- 最后修改日期
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
from ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_bk o
    left join ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.on_acct_seq_num = n.on_acct_seq_num
            and o.on_acct_sub_acct_num = n.on_acct_sub_acct_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
            and o.on_acct_seq_num = d.on_acct_seq_num
            and o.on_acct_sub_acct_num = d.on_acct_sub_acct_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_cust_on_acct_tran;
--alter table ${iml_schema}.evt_cust_on_acct_tran truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_cust_on_acct_tran') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_cust_on_acct_tran drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_cust_on_acct_tran modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_cust_on_acct_tran exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_cl;
alter table ${iml_schema}.evt_cust_on_acct_tran exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_cust_on_acct_tran to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_tm purge;
drop table ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_op purge;
drop table ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_cust_on_acct_tran_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_cust_on_acct_tran', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
