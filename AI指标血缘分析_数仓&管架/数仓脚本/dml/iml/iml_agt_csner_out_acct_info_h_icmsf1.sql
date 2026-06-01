/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_csner_out_acct_info_h_icmsf1
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
alter table ${iml_schema}.agt_csner_out_acct_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_csner_out_acct_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,csner_cust_id -- 委托人客户编号
    ,csner_name -- 委托人名称
    ,csner_acct_id -- 委托人账户编号
    ,csner_dep_acct_name -- 委托人存款账户名称
    ,csner_type_cd -- 委托人类型代码
    ,entr_dep_acct_id -- 委托存款账户账号
    ,entr_dep_acct_name -- 委托存款账户名称
    ,dubil_id -- 借据编号
    ,borw_cont_id -- 借款合同编号
    ,brwer_cust_id -- 借款人客户编号
    ,brwer_name -- 借款人名称
    ,pric_rtn_enter_id -- 本金归还入账账户编号
    ,pric_rtn_enter_name -- 本金归还入账账户名称
    ,stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,stamp_tax_tax_acct_name -- 印花税扣税账户名称
    ,comm_fee_coll_acct_id -- 手续费收取账户编号
    ,comm_fee_coll_acct_name -- 手续费收取账户名称
    ,int_rtn_enter_id -- 利息归还入账账户编号
    ,int_rtn_enter_name -- 利息归还入账账户名称
    ,cap_src_cd -- 资金来源代码
    ,csner_open_bank_num -- 委托人开户行号
    ,csner_open_bank_name -- 委托人开户行名称
    ,csner_cert_no -- 委托人证件号码
    ,csner_cert_type_cd -- 委托人证件类型代码
    ,entr_loan_dir_cd -- 委托贷款投向代码
    ,entr_loan_subclass_cd -- 委托贷款细类代码
    ,natnal_econ_gen_cd -- 国民经济大类代码
    ,natnal_econ_sub_type_cd -- 国民经济子类代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_csner_out_acct_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_csner_out_acct_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_csner_out_acct_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_pvp_consignor_info
insert into ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,csner_cust_id -- 委托人客户编号
    ,csner_name -- 委托人名称
    ,csner_acct_id -- 委托人账户编号
    ,csner_dep_acct_name -- 委托人存款账户名称
    ,csner_type_cd -- 委托人类型代码
    ,entr_dep_acct_id -- 委托存款账户账号
    ,entr_dep_acct_name -- 委托存款账户名称
    ,dubil_id -- 借据编号
    ,borw_cont_id -- 借款合同编号
    ,brwer_cust_id -- 借款人客户编号
    ,brwer_name -- 借款人名称
    ,pric_rtn_enter_id -- 本金归还入账账户编号
    ,pric_rtn_enter_name -- 本金归还入账账户名称
    ,stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,stamp_tax_tax_acct_name -- 印花税扣税账户名称
    ,comm_fee_coll_acct_id -- 手续费收取账户编号
    ,comm_fee_coll_acct_name -- 手续费收取账户名称
    ,int_rtn_enter_id -- 利息归还入账账户编号
    ,int_rtn_enter_name -- 利息归还入账账户名称
    ,cap_src_cd -- 资金来源代码
    ,csner_open_bank_num -- 委托人开户行号
    ,csner_open_bank_name -- 委托人开户行名称
    ,csner_cert_no -- 委托人证件号码
    ,csner_cert_type_cd -- 委托人证件类型代码
    ,entr_loan_dir_cd -- 委托贷款投向代码
    ,entr_loan_subclass_cd -- 委托贷款细类代码
    ,natnal_econ_gen_cd -- 国民经济大类代码
    ,natnal_econ_sub_type_cd -- 国民经济子类代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206001'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 流水号
    ,P1.CONSIGNORID -- 委托人客户编号
    ,P1.CONSIGNORNAME -- 委托人名称
    ,P1.DEPACCOUNT -- 委托人账户编号
    ,P1.DEPACCOUNTNAME -- 委托人存款账户名称
    ,nvl(trim(P1.CONSIGNORTYPE),'-') -- 委托人类型代码
    ,P1.ENTRUSTDEPACCOUNT -- 委托存款账户编号
    ,P1.ENTRUSTDEPACCOUNTNAME -- 委托存款账户名称
    ,P1.BILLNO -- 借据编号
    ,P1.CONTNO -- 借款合同编号
    ,P1.CUSID -- 借款人客户编号
    ,P1.CUSNAME -- 借款人名称
    ,P1.CAPACCOUNT -- 本金归还入账账户编号
    ,P1.CAPACCOUNTNAME -- 本金归还入账账户名称
    ,P1.TAXACCOUNT -- 印花税扣税账户编号
    ,P1.TAXACCOUNTNAME -- 印花税扣税账户名称
    ,P1.FEEACCOUNT -- 手续费收取账户编号
    ,P1.FEEACCOUNTNAME -- 手续费收取账户名称
    ,P1.INTACCOUNT -- 利息归还入账账户编号
    ,P1.INTACCOUNTNAME -- 利息归还入账账户名称
    ,nvl(trim(P1.FUNDSPROVIDED),'-') -- 资金来源代码
    ,P1.ENTRUSTDEPACCOUNTBANK -- 委托人开户行号
    ,P1.ENTRUSTDEPACCOUNTBANKNAME -- 委托人开户行名称
    ,P1.CONSIGNORCERTNO -- 委托人证件号码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CONSIGNORCERTTYPE END -- 委托人证件类型代码
    ,nvl(trim(P1.ENTRUSTDEPDUSTRYTYPE),'-') -- 委托贷款投向代码
    ,nvl(trim(P1.ENTRUSTDEPTYPESUB),'-') -- 委托贷款细类代码
    ,nvl(trim(P1.NATIONALECONOMYCATEGORY),'000') -- 国民经济大类代码
    ,nvl(trim(P1.NATIONALECONOMYSUBCLASS),'000') -- 国民经济子类代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_pvp_consignor_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_pvp_consignor_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CONSIGNORCERTTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_PVP_CONSIGNOR_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'CONSIGNORCERTTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_CSNER_OUT_ACCT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CSNER_CERT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
  	                                        ,flow_num
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
        into ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,csner_cust_id -- 委托人客户编号
    ,csner_name -- 委托人名称
    ,csner_acct_id -- 委托人账户编号
    ,csner_dep_acct_name -- 委托人存款账户名称
    ,csner_type_cd -- 委托人类型代码
    ,entr_dep_acct_id -- 委托存款账户账号
    ,entr_dep_acct_name -- 委托存款账户名称
    ,dubil_id -- 借据编号
    ,borw_cont_id -- 借款合同编号
    ,brwer_cust_id -- 借款人客户编号
    ,brwer_name -- 借款人名称
    ,pric_rtn_enter_id -- 本金归还入账账户编号
    ,pric_rtn_enter_name -- 本金归还入账账户名称
    ,stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,stamp_tax_tax_acct_name -- 印花税扣税账户名称
    ,comm_fee_coll_acct_id -- 手续费收取账户编号
    ,comm_fee_coll_acct_name -- 手续费收取账户名称
    ,int_rtn_enter_id -- 利息归还入账账户编号
    ,int_rtn_enter_name -- 利息归还入账账户名称
    ,cap_src_cd -- 资金来源代码
    ,csner_open_bank_num -- 委托人开户行号
    ,csner_open_bank_name -- 委托人开户行名称
    ,csner_cert_no -- 委托人证件号码
    ,csner_cert_type_cd -- 委托人证件类型代码
    ,entr_loan_dir_cd -- 委托贷款投向代码
    ,entr_loan_subclass_cd -- 委托贷款细类代码
    ,natnal_econ_gen_cd -- 国民经济大类代码
    ,natnal_econ_sub_type_cd -- 国民经济子类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,csner_cust_id -- 委托人客户编号
    ,csner_name -- 委托人名称
    ,csner_acct_id -- 委托人账户编号
    ,csner_dep_acct_name -- 委托人存款账户名称
    ,csner_type_cd -- 委托人类型代码
    ,entr_dep_acct_id -- 委托存款账户账号
    ,entr_dep_acct_name -- 委托存款账户名称
    ,dubil_id -- 借据编号
    ,borw_cont_id -- 借款合同编号
    ,brwer_cust_id -- 借款人客户编号
    ,brwer_name -- 借款人名称
    ,pric_rtn_enter_id -- 本金归还入账账户编号
    ,pric_rtn_enter_name -- 本金归还入账账户名称
    ,stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,stamp_tax_tax_acct_name -- 印花税扣税账户名称
    ,comm_fee_coll_acct_id -- 手续费收取账户编号
    ,comm_fee_coll_acct_name -- 手续费收取账户名称
    ,int_rtn_enter_id -- 利息归还入账账户编号
    ,int_rtn_enter_name -- 利息归还入账账户名称
    ,cap_src_cd -- 资金来源代码
    ,csner_open_bank_num -- 委托人开户行号
    ,csner_open_bank_name -- 委托人开户行名称
    ,csner_cert_no -- 委托人证件号码
    ,csner_cert_type_cd -- 委托人证件类型代码
    ,entr_loan_dir_cd -- 委托贷款投向代码
    ,entr_loan_subclass_cd -- 委托贷款细类代码
    ,natnal_econ_gen_cd -- 国民经济大类代码
    ,natnal_econ_sub_type_cd -- 国民经济子类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.flow_num, o.flow_num) as flow_num -- 流水号
    ,nvl(n.csner_cust_id, o.csner_cust_id) as csner_cust_id -- 委托人客户编号
    ,nvl(n.csner_name, o.csner_name) as csner_name -- 委托人名称
    ,nvl(n.csner_acct_id, o.csner_acct_id) as csner_acct_id -- 委托人账户编号
    ,nvl(n.csner_dep_acct_name, o.csner_dep_acct_name) as csner_dep_acct_name -- 委托人存款账户名称
    ,nvl(n.csner_type_cd, o.csner_type_cd) as csner_type_cd -- 委托人类型代码
    ,nvl(n.entr_dep_acct_id, o.entr_dep_acct_id) as entr_dep_acct_id -- 委托存款账户账号
    ,nvl(n.entr_dep_acct_name, o.entr_dep_acct_name) as entr_dep_acct_name -- 委托存款账户名称
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.borw_cont_id, o.borw_cont_id) as borw_cont_id -- 借款合同编号
    ,nvl(n.brwer_cust_id, o.brwer_cust_id) as brwer_cust_id -- 借款人客户编号
    ,nvl(n.brwer_name, o.brwer_name) as brwer_name -- 借款人名称
    ,nvl(n.pric_rtn_enter_id, o.pric_rtn_enter_id) as pric_rtn_enter_id -- 本金归还入账账户编号
    ,nvl(n.pric_rtn_enter_name, o.pric_rtn_enter_name) as pric_rtn_enter_name -- 本金归还入账账户名称
    ,nvl(n.stamp_tax_tax_acct_id, o.stamp_tax_tax_acct_id) as stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,nvl(n.stamp_tax_tax_acct_name, o.stamp_tax_tax_acct_name) as stamp_tax_tax_acct_name -- 印花税扣税账户名称
    ,nvl(n.comm_fee_coll_acct_id, o.comm_fee_coll_acct_id) as comm_fee_coll_acct_id -- 手续费收取账户编号
    ,nvl(n.comm_fee_coll_acct_name, o.comm_fee_coll_acct_name) as comm_fee_coll_acct_name -- 手续费收取账户名称
    ,nvl(n.int_rtn_enter_id, o.int_rtn_enter_id) as int_rtn_enter_id -- 利息归还入账账户编号
    ,nvl(n.int_rtn_enter_name, o.int_rtn_enter_name) as int_rtn_enter_name -- 利息归还入账账户名称
    ,nvl(n.cap_src_cd, o.cap_src_cd) as cap_src_cd -- 资金来源代码
    ,nvl(n.csner_open_bank_num, o.csner_open_bank_num) as csner_open_bank_num -- 委托人开户行号
    ,nvl(n.csner_open_bank_name, o.csner_open_bank_name) as csner_open_bank_name -- 委托人开户行名称
    ,nvl(n.csner_cert_no, o.csner_cert_no) as csner_cert_no -- 委托人证件号码
    ,nvl(n.csner_cert_type_cd, o.csner_cert_type_cd) as csner_cert_type_cd -- 委托人证件类型代码
    ,nvl(n.entr_loan_dir_cd, o.entr_loan_dir_cd) as entr_loan_dir_cd -- 委托贷款投向代码
    ,nvl(n.entr_loan_subclass_cd, o.entr_loan_subclass_cd) as entr_loan_subclass_cd -- 委托贷款细类代码
    ,nvl(n.natnal_econ_gen_cd, o.natnal_econ_gen_cd) as natnal_econ_gen_cd -- 国民经济大类代码
    ,nvl(n.natnal_econ_sub_type_cd, o.natnal_econ_sub_type_cd) as natnal_econ_sub_type_cd -- 国民经济子类代码
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.flow_num = n.flow_num
where (
        o.appl_id is null
        and o.lp_id is null
        and o.flow_num is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
        and n.flow_num is null
    )
    or (
        o.csner_cust_id <> n.csner_cust_id
        or o.csner_name <> n.csner_name
        or o.csner_acct_id <> n.csner_acct_id
        or o.csner_dep_acct_name <> n.csner_dep_acct_name
        or o.csner_type_cd <> n.csner_type_cd
        or o.entr_dep_acct_id <> n.entr_dep_acct_id
        or o.entr_dep_acct_name <> n.entr_dep_acct_name
        or o.dubil_id <> n.dubil_id
        or o.borw_cont_id <> n.borw_cont_id
        or o.brwer_cust_id <> n.brwer_cust_id
        or o.brwer_name <> n.brwer_name
        or o.pric_rtn_enter_id <> n.pric_rtn_enter_id
        or o.pric_rtn_enter_name <> n.pric_rtn_enter_name
        or o.stamp_tax_tax_acct_id <> n.stamp_tax_tax_acct_id
        or o.stamp_tax_tax_acct_name <> n.stamp_tax_tax_acct_name
        or o.comm_fee_coll_acct_id <> n.comm_fee_coll_acct_id
        or o.comm_fee_coll_acct_name <> n.comm_fee_coll_acct_name
        or o.int_rtn_enter_id <> n.int_rtn_enter_id
        or o.int_rtn_enter_name <> n.int_rtn_enter_name
        or o.cap_src_cd <> n.cap_src_cd
        or o.csner_open_bank_num <> n.csner_open_bank_num
        or o.csner_open_bank_name <> n.csner_open_bank_name
        or o.csner_cert_no <> n.csner_cert_no
        or o.csner_cert_type_cd <> n.csner_cert_type_cd
        or o.entr_loan_dir_cd <> n.entr_loan_dir_cd
        or o.entr_loan_subclass_cd <> n.entr_loan_subclass_cd
        or o.natnal_econ_gen_cd <> n.natnal_econ_gen_cd
        or o.natnal_econ_sub_type_cd <> n.natnal_econ_sub_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,csner_cust_id -- 委托人客户编号
    ,csner_name -- 委托人名称
    ,csner_acct_id -- 委托人账户编号
    ,csner_dep_acct_name -- 委托人存款账户名称
    ,csner_type_cd -- 委托人类型代码
    ,entr_dep_acct_id -- 委托存款账户账号
    ,entr_dep_acct_name -- 委托存款账户名称
    ,dubil_id -- 借据编号
    ,borw_cont_id -- 借款合同编号
    ,brwer_cust_id -- 借款人客户编号
    ,brwer_name -- 借款人名称
    ,pric_rtn_enter_id -- 本金归还入账账户编号
    ,pric_rtn_enter_name -- 本金归还入账账户名称
    ,stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,stamp_tax_tax_acct_name -- 印花税扣税账户名称
    ,comm_fee_coll_acct_id -- 手续费收取账户编号
    ,comm_fee_coll_acct_name -- 手续费收取账户名称
    ,int_rtn_enter_id -- 利息归还入账账户编号
    ,int_rtn_enter_name -- 利息归还入账账户名称
    ,cap_src_cd -- 资金来源代码
    ,csner_open_bank_num -- 委托人开户行号
    ,csner_open_bank_name -- 委托人开户行名称
    ,csner_cert_no -- 委托人证件号码
    ,csner_cert_type_cd -- 委托人证件类型代码
    ,entr_loan_dir_cd -- 委托贷款投向代码
    ,entr_loan_subclass_cd -- 委托贷款细类代码
    ,natnal_econ_gen_cd -- 国民经济大类代码
    ,natnal_econ_sub_type_cd -- 国民经济子类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,csner_cust_id -- 委托人客户编号
    ,csner_name -- 委托人名称
    ,csner_acct_id -- 委托人账户编号
    ,csner_dep_acct_name -- 委托人存款账户名称
    ,csner_type_cd -- 委托人类型代码
    ,entr_dep_acct_id -- 委托存款账户账号
    ,entr_dep_acct_name -- 委托存款账户名称
    ,dubil_id -- 借据编号
    ,borw_cont_id -- 借款合同编号
    ,brwer_cust_id -- 借款人客户编号
    ,brwer_name -- 借款人名称
    ,pric_rtn_enter_id -- 本金归还入账账户编号
    ,pric_rtn_enter_name -- 本金归还入账账户名称
    ,stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,stamp_tax_tax_acct_name -- 印花税扣税账户名称
    ,comm_fee_coll_acct_id -- 手续费收取账户编号
    ,comm_fee_coll_acct_name -- 手续费收取账户名称
    ,int_rtn_enter_id -- 利息归还入账账户编号
    ,int_rtn_enter_name -- 利息归还入账账户名称
    ,cap_src_cd -- 资金来源代码
    ,csner_open_bank_num -- 委托人开户行号
    ,csner_open_bank_name -- 委托人开户行名称
    ,csner_cert_no -- 委托人证件号码
    ,csner_cert_type_cd -- 委托人证件类型代码
    ,entr_loan_dir_cd -- 委托贷款投向代码
    ,entr_loan_subclass_cd -- 委托贷款细类代码
    ,natnal_econ_gen_cd -- 国民经济大类代码
    ,natnal_econ_sub_type_cd -- 国民经济子类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.flow_num -- 流水号
    ,o.csner_cust_id -- 委托人客户编号
    ,o.csner_name -- 委托人名称
    ,o.csner_acct_id -- 委托人账户编号
    ,o.csner_dep_acct_name -- 委托人存款账户名称
    ,o.csner_type_cd -- 委托人类型代码
    ,o.entr_dep_acct_id -- 委托存款账户账号
    ,o.entr_dep_acct_name -- 委托存款账户名称
    ,o.dubil_id -- 借据编号
    ,o.borw_cont_id -- 借款合同编号
    ,o.brwer_cust_id -- 借款人客户编号
    ,o.brwer_name -- 借款人名称
    ,o.pric_rtn_enter_id -- 本金归还入账账户编号
    ,o.pric_rtn_enter_name -- 本金归还入账账户名称
    ,o.stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,o.stamp_tax_tax_acct_name -- 印花税扣税账户名称
    ,o.comm_fee_coll_acct_id -- 手续费收取账户编号
    ,o.comm_fee_coll_acct_name -- 手续费收取账户名称
    ,o.int_rtn_enter_id -- 利息归还入账账户编号
    ,o.int_rtn_enter_name -- 利息归还入账账户名称
    ,o.cap_src_cd -- 资金来源代码
    ,o.csner_open_bank_num -- 委托人开户行号
    ,o.csner_open_bank_name -- 委托人开户行名称
    ,o.csner_cert_no -- 委托人证件号码
    ,o.csner_cert_type_cd -- 委托人证件类型代码
    ,o.entr_loan_dir_cd -- 委托贷款投向代码
    ,o.entr_loan_subclass_cd -- 委托贷款细类代码
    ,o.natnal_econ_gen_cd -- 国民经济大类代码
    ,o.natnal_econ_sub_type_cd -- 国民经济子类代码
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
from ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.flow_num = n.flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
            and o.flow_num = d.flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_csner_out_acct_info_h;
--alter table ${iml_schema}.agt_csner_out_acct_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_csner_out_acct_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_csner_out_acct_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_csner_out_acct_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_csner_out_acct_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_csner_out_acct_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_csner_out_acct_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_csner_out_acct_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_csner_out_acct_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
