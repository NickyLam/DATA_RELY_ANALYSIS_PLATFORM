/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_digit_curr_agt_info_h_mpcsf1
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
alter table ${iml_schema}.agt_digit_curr_agt_info_h add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_digit_curr_agt_info_h partition for ('mpcsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,src_agt_id -- 源协议编号
    ,sign_status_cd -- 签约状态代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_cert_type_cd -- 签约证件类型代码
    ,sign_cert_no -- 签约证件号码
    ,sign_cert_invalid_dt -- 签约证件失效日期
    ,sign_belong_org_id -- 签约所属机构编号
    ,sign_belong_org_name -- 签约所属机构名称
    ,sign_dt -- 签约日期
    ,sign_termn_cd -- 签约终端代码
    ,sign_teller_id -- 签约柜员编号
    ,rsrv_mobile_no -- 预留手机号码
    ,pkg_open_belong_org_id -- 钱包开立所属机构编号
    ,pkg_open_belong_org_name -- 钱包开立所属机构名称
    ,pkg_id -- 钱包编号
    ,pkg_type_cd -- 钱包类型代码
    ,pkg_level_cd -- 钱包等级代码
    ,rels_flow_num -- 解约流水号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,aldy_change_card_flg -- 已换卡标志
    ,new_card_acct_id -- 新卡账户编号
    ,change_card_tm -- 换卡时间
    ,init_init_org_id -- 原发起机构编号
    ,corp_name -- 单位名称
    ,corp_princ_name -- 单位负责人名称
    ,corp_princ_cert_type_cd -- 单位负责人证件类型代码
    ,corp_princ_cert_no -- 单位负责人证件号码
    ,sig_acpt_bus_amt_uplmi -- 单笔兑出业务金额上限
    ,d_acm_acpt_bus_upcnt -- 日累计兑出业务笔数上限
    ,d_acm_acpt_bus_uplmi -- 日累计兑出业务金额上限
    ,y_acm_acpt_bus_upcnt -- 年累计兑出业务笔数上限
    ,y_acm_acpt_bus_uplmi -- 年累计兑出业务金额上限
    ,mgmt_org_id -- 管理机构编号
    ,msg_id -- 报文编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_digit_curr_agt_info_h partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_digit_curr_agt_info_h partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_digit_curr_agt_info_h partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a1stacctptcidinfo-1
insert into ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,src_agt_id -- 源协议编号
    ,sign_status_cd -- 签约状态代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_cert_type_cd -- 签约证件类型代码
    ,sign_cert_no -- 签约证件号码
    ,sign_cert_invalid_dt -- 签约证件失效日期
    ,sign_belong_org_id -- 签约所属机构编号
    ,sign_belong_org_name -- 签约所属机构名称
    ,sign_dt -- 签约日期
    ,sign_termn_cd -- 签约终端代码
    ,sign_teller_id -- 签约柜员编号
    ,rsrv_mobile_no -- 预留手机号码
    ,pkg_open_belong_org_id -- 钱包开立所属机构编号
    ,pkg_open_belong_org_name -- 钱包开立所属机构名称
    ,pkg_id -- 钱包编号
    ,pkg_type_cd -- 钱包类型代码
    ,pkg_level_cd -- 钱包等级代码
    ,rels_flow_num -- 解约流水号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,aldy_change_card_flg -- 已换卡标志
    ,new_card_acct_id -- 新卡账户编号
    ,change_card_tm -- 换卡时间
    ,init_init_org_id -- 原发起机构编号
    ,corp_name -- 单位名称
    ,corp_princ_name -- 单位负责人名称
    ,corp_princ_cert_type_cd -- 单位负责人证件类型代码
    ,corp_princ_cert_no -- 单位负责人证件号码
    ,sig_acpt_bus_amt_uplmi -- 单笔兑出业务金额上限
    ,d_acm_acpt_bus_upcnt -- 日累计兑出业务笔数上限
    ,d_acm_acpt_bus_uplmi -- 日累计兑出业务金额上限
    ,y_acm_acpt_bus_upcnt -- 年累计兑出业务笔数上限
    ,y_acm_acpt_bus_uplmi -- 年累计兑出业务金额上限
    ,mgmt_org_id -- 管理机构编号
    ,msg_id -- 报文编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300053'||P1.MAINSEQ -- 协议编号
    ,'9999' -- 法人编号
    ,P1.MAINSEQ -- 中台流水号
    ,${iml_schema}.dateformat_max2(P1.TRANSDT||P1.TRNTM) -- 中台交易日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL  ELSE '@'||P1.CUSTTYPE END -- 客户类型代码
    ,P1.CUSTNO -- 客户编号
    ,P1.PTCIDNO -- 源协议编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.MANAGEMENTTYPE END -- 签约状态代码
    ,${iml_schema}.dateformat_min(P1.PTCFCTVDT) -- 协议生效日期
    ,${iml_schema}.dateformat_max2(P1.PTCIFCTVDT) -- 协议失效日期
    ,P1.SGNACCTIDKEY -- 签约账户编号
    ,P1.SGNACCTNMKEY -- 签约账户名称
    ,P1.SGNACCTTP -- 签约账户类型代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.IDTYPE END -- 签约证件类型代码
    ,P1.IDNUMBERKEY -- 签约证件号码
    ,${iml_schema}.dateformat_max2(P1.IDENDUEDT) -- 签约证件失效日期
    ,P1.SGNACCTPTYID -- 签约所属机构编号
    ,P1.SGNACCTPTYNAME -- 签约所属机构名称
    ,${iml_schema}.dateformat_min(P1.FISTTIME) -- 签约日期
    ,CASE 
       WHEN R5.TARGET_CD_VAL IS NOT NULL THEN 
        R5.TARGET_CD_VAL 
       ELSE 
        '@'||P1.SGNCHNL
     END -- 签约终端代码
    ,P1.FISTTLR -- 签约柜员编号
    ,P1.TELEPHONEKEY -- 预留手机号码
    ,P1.WALTETPTYID -- 钱包开立所属机构编号
    ,P1.WALTETPTYNAME -- 钱包开立所属机构名称
    ,P1.WALTETIDKEY -- 钱包编号
    ,nvl(trim(P1.WALTETTYPE),'-') -- 钱包类型代码
    ,nvl(trim(P1.WALLETLEVEL),'-') -- 钱包等级代码
    ,P1.UNSIGNSEQNO -- 解约流水号
    ,${iml_schema}.dateformat_max2(P1.RECVTIME) -- 解约日期
    ,P1.RECVTLR -- 解约柜员编号
    ,nvl(trim(P1.REFLAG),'-') -- 已换卡标志
    ,P1.NEWSGNACCTID -- 新卡账户编号
    ,${iml_schema}.dateformat_max2(P1.CHGTIME) -- 换卡时间
    ,P1.SNDBRN -- 原发起机构编号
    ,P1.CORPRTNNM -- 单位名称
    ,P1.LGLREPNM -- 单位负责人名称
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.LGLREPIDTP END -- 单位负责人证件类型代码
    ,P1.LGLREPIDNO -- 单位负责人证件号码
    ,to_number(nvl(trim(P1.SNGLTXAMTLMT),0)) -- 单笔兑出业务金额上限
    ,to_number(nvl(trim(P1.DLTTLCNT),0)) -- 日累计兑出业务笔数上限
    ,to_number(nvl(trim(P1.DLTTLAMTLMT),0)) -- 日累计兑出业务金额上限
    ,to_number(nvl(trim(P1.ANLTTLCNT),0)) -- 年累计兑出业务笔数上限
    ,to_number(nvl(trim(P1.ANLTTLAMTLMT),0)) -- 年累计兑出业务金额上限
    ,P1.MAGEBRN -- 管理机构编号
    ,P1.PCKNO -- 报文编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a1stacctptcidinfo' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a1stacctptcidinfo p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CUSTTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A1STACCTPTCIDINFO'
        AND R1.SRC_FIELD_EN_NAME= 'CUSTTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_DIGIT_CURR_AGT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.MANAGEMENTTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A1STACCTPTCIDINFO'
        AND R2.SRC_FIELD_EN_NAME= 'MANAGEMENTTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_DIGIT_CURR_AGT_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'SIGN_STATUS_CD'
    /*left join ${iml_schema}.ref_pub_cd_map r3 on P1.SGNACCTTP = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A1STACCTPTCIDINFO'
        AND R3.SRC_FIELD_EN_NAME= 'SGNACCTTP'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_DIGIT_CURR_AGT_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'SIGN_ACCT_TYPE_CD'*/
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.IDTYPE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A1STACCTPTCIDINFO'
        AND R4.SRC_FIELD_EN_NAME= 'IDTYPE'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_DIGIT_CURR_AGT_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'SIGN_CERT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.SGNCHNL = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MPCS'
        AND R5.SRC_TAB_EN_NAME= 'MPCS_A1STACCTPTCIDINFO'
        AND R5.SRC_FIELD_EN_NAME= 'SGNCHNL'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_DIGIT_CURR_AGT_INFO_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'SIGN_TERMN_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.LGLREPIDTP = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'MPCS'
        AND R6.SRC_TAB_EN_NAME= 'MPCS_A1STACCTPTCIDINFO'
        AND R6.SRC_FIELD_EN_NAME= 'LGLREPIDTP'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_DIGIT_CURR_AGT_INFO_H'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'CORP_PRINC_CERT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
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
        into ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,src_agt_id -- 源协议编号
    ,sign_status_cd -- 签约状态代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_cert_type_cd -- 签约证件类型代码
    ,sign_cert_no -- 签约证件号码
    ,sign_cert_invalid_dt -- 签约证件失效日期
    ,sign_belong_org_id -- 签约所属机构编号
    ,sign_belong_org_name -- 签约所属机构名称
    ,sign_dt -- 签约日期
    ,sign_termn_cd -- 签约终端代码
    ,sign_teller_id -- 签约柜员编号
    ,rsrv_mobile_no -- 预留手机号码
    ,pkg_open_belong_org_id -- 钱包开立所属机构编号
    ,pkg_open_belong_org_name -- 钱包开立所属机构名称
    ,pkg_id -- 钱包编号
    ,pkg_type_cd -- 钱包类型代码
    ,pkg_level_cd -- 钱包等级代码
    ,rels_flow_num -- 解约流水号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,aldy_change_card_flg -- 已换卡标志
    ,new_card_acct_id -- 新卡账户编号
    ,change_card_tm -- 换卡时间
    ,init_init_org_id -- 原发起机构编号
    ,corp_name -- 单位名称
    ,corp_princ_name -- 单位负责人名称
    ,corp_princ_cert_type_cd -- 单位负责人证件类型代码
    ,corp_princ_cert_no -- 单位负责人证件号码
    ,sig_acpt_bus_amt_uplmi -- 单笔兑出业务金额上限
    ,d_acm_acpt_bus_upcnt -- 日累计兑出业务笔数上限
    ,d_acm_acpt_bus_uplmi -- 日累计兑出业务金额上限
    ,y_acm_acpt_bus_upcnt -- 年累计兑出业务笔数上限
    ,y_acm_acpt_bus_uplmi -- 年累计兑出业务金额上限
    ,mgmt_org_id -- 管理机构编号
    ,msg_id -- 报文编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,src_agt_id -- 源协议编号
    ,sign_status_cd -- 签约状态代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_cert_type_cd -- 签约证件类型代码
    ,sign_cert_no -- 签约证件号码
    ,sign_cert_invalid_dt -- 签约证件失效日期
    ,sign_belong_org_id -- 签约所属机构编号
    ,sign_belong_org_name -- 签约所属机构名称
    ,sign_dt -- 签约日期
    ,sign_termn_cd -- 签约终端代码
    ,sign_teller_id -- 签约柜员编号
    ,rsrv_mobile_no -- 预留手机号码
    ,pkg_open_belong_org_id -- 钱包开立所属机构编号
    ,pkg_open_belong_org_name -- 钱包开立所属机构名称
    ,pkg_id -- 钱包编号
    ,pkg_type_cd -- 钱包类型代码
    ,pkg_level_cd -- 钱包等级代码
    ,rels_flow_num -- 解约流水号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,aldy_change_card_flg -- 已换卡标志
    ,new_card_acct_id -- 新卡账户编号
    ,change_card_tm -- 换卡时间
    ,init_init_org_id -- 原发起机构编号
    ,corp_name -- 单位名称
    ,corp_princ_name -- 单位负责人名称
    ,corp_princ_cert_type_cd -- 单位负责人证件类型代码
    ,corp_princ_cert_no -- 单位负责人证件号码
    ,sig_acpt_bus_amt_uplmi -- 单笔兑出业务金额上限
    ,d_acm_acpt_bus_upcnt -- 日累计兑出业务笔数上限
    ,d_acm_acpt_bus_uplmi -- 日累计兑出业务金额上限
    ,y_acm_acpt_bus_upcnt -- 年累计兑出业务笔数上限
    ,y_acm_acpt_bus_uplmi -- 年累计兑出业务金额上限
    ,mgmt_org_id -- 管理机构编号
    ,msg_id -- 报文编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.midgrod_flow_num, o.midgrod_flow_num) as midgrod_flow_num -- 中台流水号
    ,nvl(n.midgrod_tran_dt, o.midgrod_tran_dt) as midgrod_tran_dt -- 中台交易日期
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.sign_status_cd, o.sign_status_cd) as sign_status_cd -- 签约状态代码
    ,nvl(n.agt_effect_dt, o.agt_effect_dt) as agt_effect_dt -- 协议生效日期
    ,nvl(n.agt_invalid_dt, o.agt_invalid_dt) as agt_invalid_dt -- 协议失效日期
    ,nvl(n.sign_acct_id, o.sign_acct_id) as sign_acct_id -- 签约账户编号
    ,nvl(n.sign_acct_name, o.sign_acct_name) as sign_acct_name -- 签约账户名称
    ,nvl(n.sign_acct_type_cd, o.sign_acct_type_cd) as sign_acct_type_cd -- 签约账户类型代码
    ,nvl(n.sign_cert_type_cd, o.sign_cert_type_cd) as sign_cert_type_cd -- 签约证件类型代码
    ,nvl(n.sign_cert_no, o.sign_cert_no) as sign_cert_no -- 签约证件号码
    ,nvl(n.sign_cert_invalid_dt, o.sign_cert_invalid_dt) as sign_cert_invalid_dt -- 签约证件失效日期
    ,nvl(n.sign_belong_org_id, o.sign_belong_org_id) as sign_belong_org_id -- 签约所属机构编号
    ,nvl(n.sign_belong_org_name, o.sign_belong_org_name) as sign_belong_org_name -- 签约所属机构名称
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签约日期
    ,nvl(n.sign_termn_cd, o.sign_termn_cd) as sign_termn_cd -- 签约终端代码
    ,nvl(n.sign_teller_id, o.sign_teller_id) as sign_teller_id -- 签约柜员编号
    ,nvl(n.rsrv_mobile_no, o.rsrv_mobile_no) as rsrv_mobile_no -- 预留手机号码
    ,nvl(n.pkg_open_belong_org_id, o.pkg_open_belong_org_id) as pkg_open_belong_org_id -- 钱包开立所属机构编号
    ,nvl(n.pkg_open_belong_org_name, o.pkg_open_belong_org_name) as pkg_open_belong_org_name -- 钱包开立所属机构名称
    ,nvl(n.pkg_id, o.pkg_id) as pkg_id -- 钱包编号
    ,nvl(n.pkg_type_cd, o.pkg_type_cd) as pkg_type_cd -- 钱包类型代码
    ,nvl(n.pkg_level_cd, o.pkg_level_cd) as pkg_level_cd -- 钱包等级代码
    ,nvl(n.rels_flow_num, o.rels_flow_num) as rels_flow_num -- 解约流水号
    ,nvl(n.rels_dt, o.rels_dt) as rels_dt -- 解约日期
    ,nvl(n.rels_teller_id, o.rels_teller_id) as rels_teller_id -- 解约柜员编号
    ,nvl(n.aldy_change_card_flg, o.aldy_change_card_flg) as aldy_change_card_flg -- 已换卡标志
    ,nvl(n.new_card_acct_id, o.new_card_acct_id) as new_card_acct_id -- 新卡账户编号
    ,nvl(n.change_card_tm, o.change_card_tm) as change_card_tm -- 换卡时间
    ,nvl(n.init_init_org_id, o.init_init_org_id) as init_init_org_id -- 原发起机构编号
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 单位名称
    ,nvl(n.corp_princ_name, o.corp_princ_name) as corp_princ_name -- 单位负责人名称
    ,nvl(n.corp_princ_cert_type_cd, o.corp_princ_cert_type_cd) as corp_princ_cert_type_cd -- 单位负责人证件类型代码
    ,nvl(n.corp_princ_cert_no, o.corp_princ_cert_no) as corp_princ_cert_no -- 单位负责人证件号码
    ,nvl(n.sig_acpt_bus_amt_uplmi, o.sig_acpt_bus_amt_uplmi) as sig_acpt_bus_amt_uplmi -- 单笔兑出业务金额上限
    ,nvl(n.d_acm_acpt_bus_upcnt, o.d_acm_acpt_bus_upcnt) as d_acm_acpt_bus_upcnt -- 日累计兑出业务笔数上限
    ,nvl(n.d_acm_acpt_bus_uplmi, o.d_acm_acpt_bus_uplmi) as d_acm_acpt_bus_uplmi -- 日累计兑出业务金额上限
    ,nvl(n.y_acm_acpt_bus_upcnt, o.y_acm_acpt_bus_upcnt) as y_acm_acpt_bus_upcnt -- 年累计兑出业务笔数上限
    ,nvl(n.y_acm_acpt_bus_uplmi, o.y_acm_acpt_bus_uplmi) as y_acm_acpt_bus_uplmi -- 年累计兑出业务金额上限
    ,nvl(n.mgmt_org_id, o.mgmt_org_id) as mgmt_org_id -- 管理机构编号
    ,nvl(n.msg_id, o.msg_id) as msg_id -- 报文编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_tm n
    full join (select * from ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.midgrod_flow_num <> n.midgrod_flow_num
        or o.midgrod_tran_dt <> n.midgrod_tran_dt
        or o.cust_type_cd <> n.cust_type_cd
        or o.cust_id <> n.cust_id
        or o.src_agt_id <> n.src_agt_id
        or o.sign_status_cd <> n.sign_status_cd
        or o.agt_effect_dt <> n.agt_effect_dt
        or o.agt_invalid_dt <> n.agt_invalid_dt
        or o.sign_acct_id <> n.sign_acct_id
        or o.sign_acct_name <> n.sign_acct_name
        or o.sign_acct_type_cd <> n.sign_acct_type_cd
        or o.sign_cert_type_cd <> n.sign_cert_type_cd
        or o.sign_cert_no <> n.sign_cert_no
        or o.sign_cert_invalid_dt <> n.sign_cert_invalid_dt
        or o.sign_belong_org_id <> n.sign_belong_org_id
        or o.sign_belong_org_name <> n.sign_belong_org_name
        or o.sign_dt <> n.sign_dt
        or o.sign_termn_cd <> n.sign_termn_cd
        or o.sign_teller_id <> n.sign_teller_id
        or o.rsrv_mobile_no <> n.rsrv_mobile_no
        or o.pkg_open_belong_org_id <> n.pkg_open_belong_org_id
        or o.pkg_open_belong_org_name <> n.pkg_open_belong_org_name
        or o.pkg_id <> n.pkg_id
        or o.pkg_type_cd <> n.pkg_type_cd
        or o.pkg_level_cd <> n.pkg_level_cd
        or o.rels_flow_num <> n.rels_flow_num
        or o.rels_dt <> n.rels_dt
        or o.rels_teller_id <> n.rels_teller_id
        or o.aldy_change_card_flg <> n.aldy_change_card_flg
        or o.new_card_acct_id <> n.new_card_acct_id
        or o.change_card_tm <> n.change_card_tm
        or o.init_init_org_id <> n.init_init_org_id
        or o.corp_name <> n.corp_name
        or o.corp_princ_name <> n.corp_princ_name
        or o.corp_princ_cert_type_cd <> n.corp_princ_cert_type_cd
        or o.corp_princ_cert_no <> n.corp_princ_cert_no
        or o.sig_acpt_bus_amt_uplmi <> n.sig_acpt_bus_amt_uplmi
        or o.d_acm_acpt_bus_upcnt <> n.d_acm_acpt_bus_upcnt
        or o.d_acm_acpt_bus_uplmi <> n.d_acm_acpt_bus_uplmi
        or o.y_acm_acpt_bus_upcnt <> n.y_acm_acpt_bus_upcnt
        or o.y_acm_acpt_bus_uplmi <> n.y_acm_acpt_bus_uplmi
        or o.mgmt_org_id <> n.mgmt_org_id
        or o.msg_id <> n.msg_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,src_agt_id -- 源协议编号
    ,sign_status_cd -- 签约状态代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_cert_type_cd -- 签约证件类型代码
    ,sign_cert_no -- 签约证件号码
    ,sign_cert_invalid_dt -- 签约证件失效日期
    ,sign_belong_org_id -- 签约所属机构编号
    ,sign_belong_org_name -- 签约所属机构名称
    ,sign_dt -- 签约日期
    ,sign_termn_cd -- 签约终端代码
    ,sign_teller_id -- 签约柜员编号
    ,rsrv_mobile_no -- 预留手机号码
    ,pkg_open_belong_org_id -- 钱包开立所属机构编号
    ,pkg_open_belong_org_name -- 钱包开立所属机构名称
    ,pkg_id -- 钱包编号
    ,pkg_type_cd -- 钱包类型代码
    ,pkg_level_cd -- 钱包等级代码
    ,rels_flow_num -- 解约流水号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,aldy_change_card_flg -- 已换卡标志
    ,new_card_acct_id -- 新卡账户编号
    ,change_card_tm -- 换卡时间
    ,init_init_org_id -- 原发起机构编号
    ,corp_name -- 单位名称
    ,corp_princ_name -- 单位负责人名称
    ,corp_princ_cert_type_cd -- 单位负责人证件类型代码
    ,corp_princ_cert_no -- 单位负责人证件号码
    ,sig_acpt_bus_amt_uplmi -- 单笔兑出业务金额上限
    ,d_acm_acpt_bus_upcnt -- 日累计兑出业务笔数上限
    ,d_acm_acpt_bus_uplmi -- 日累计兑出业务金额上限
    ,y_acm_acpt_bus_upcnt -- 年累计兑出业务笔数上限
    ,y_acm_acpt_bus_uplmi -- 年累计兑出业务金额上限
    ,mgmt_org_id -- 管理机构编号
    ,msg_id -- 报文编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,src_agt_id -- 源协议编号
    ,sign_status_cd -- 签约状态代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_cert_type_cd -- 签约证件类型代码
    ,sign_cert_no -- 签约证件号码
    ,sign_cert_invalid_dt -- 签约证件失效日期
    ,sign_belong_org_id -- 签约所属机构编号
    ,sign_belong_org_name -- 签约所属机构名称
    ,sign_dt -- 签约日期
    ,sign_termn_cd -- 签约终端代码
    ,sign_teller_id -- 签约柜员编号
    ,rsrv_mobile_no -- 预留手机号码
    ,pkg_open_belong_org_id -- 钱包开立所属机构编号
    ,pkg_open_belong_org_name -- 钱包开立所属机构名称
    ,pkg_id -- 钱包编号
    ,pkg_type_cd -- 钱包类型代码
    ,pkg_level_cd -- 钱包等级代码
    ,rels_flow_num -- 解约流水号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,aldy_change_card_flg -- 已换卡标志
    ,new_card_acct_id -- 新卡账户编号
    ,change_card_tm -- 换卡时间
    ,init_init_org_id -- 原发起机构编号
    ,corp_name -- 单位名称
    ,corp_princ_name -- 单位负责人名称
    ,corp_princ_cert_type_cd -- 单位负责人证件类型代码
    ,corp_princ_cert_no -- 单位负责人证件号码
    ,sig_acpt_bus_amt_uplmi -- 单笔兑出业务金额上限
    ,d_acm_acpt_bus_upcnt -- 日累计兑出业务笔数上限
    ,d_acm_acpt_bus_uplmi -- 日累计兑出业务金额上限
    ,y_acm_acpt_bus_upcnt -- 年累计兑出业务笔数上限
    ,y_acm_acpt_bus_uplmi -- 年累计兑出业务金额上限
    ,mgmt_org_id -- 管理机构编号
    ,msg_id -- 报文编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.midgrod_flow_num -- 中台流水号
    ,o.midgrod_tran_dt -- 中台交易日期
    ,o.cust_type_cd -- 客户类型代码
    ,o.cust_id -- 客户编号
    ,o.src_agt_id -- 源协议编号
    ,o.sign_status_cd -- 签约状态代码
    ,o.agt_effect_dt -- 协议生效日期
    ,o.agt_invalid_dt -- 协议失效日期
    ,o.sign_acct_id -- 签约账户编号
    ,o.sign_acct_name -- 签约账户名称
    ,o.sign_acct_type_cd -- 签约账户类型代码
    ,o.sign_cert_type_cd -- 签约证件类型代码
    ,o.sign_cert_no -- 签约证件号码
    ,o.sign_cert_invalid_dt -- 签约证件失效日期
    ,o.sign_belong_org_id -- 签约所属机构编号
    ,o.sign_belong_org_name -- 签约所属机构名称
    ,o.sign_dt -- 签约日期
    ,o.sign_termn_cd -- 签约终端代码
    ,o.sign_teller_id -- 签约柜员编号
    ,o.rsrv_mobile_no -- 预留手机号码
    ,o.pkg_open_belong_org_id -- 钱包开立所属机构编号
    ,o.pkg_open_belong_org_name -- 钱包开立所属机构名称
    ,o.pkg_id -- 钱包编号
    ,o.pkg_type_cd -- 钱包类型代码
    ,o.pkg_level_cd -- 钱包等级代码
    ,o.rels_flow_num -- 解约流水号
    ,o.rels_dt -- 解约日期
    ,o.rels_teller_id -- 解约柜员编号
    ,o.aldy_change_card_flg -- 已换卡标志
    ,o.new_card_acct_id -- 新卡账户编号
    ,o.change_card_tm -- 换卡时间
    ,o.init_init_org_id -- 原发起机构编号
    ,o.corp_name -- 单位名称
    ,o.corp_princ_name -- 单位负责人名称
    ,o.corp_princ_cert_type_cd -- 单位负责人证件类型代码
    ,o.corp_princ_cert_no -- 单位负责人证件号码
    ,o.sig_acpt_bus_amt_uplmi -- 单笔兑出业务金额上限
    ,o.d_acm_acpt_bus_upcnt -- 日累计兑出业务笔数上限
    ,o.d_acm_acpt_bus_uplmi -- 日累计兑出业务金额上限
    ,o.y_acm_acpt_bus_upcnt -- 年累计兑出业务笔数上限
    ,o.y_acm_acpt_bus_uplmi -- 年累计兑出业务金额上限
    ,o.mgmt_org_id -- 管理机构编号
    ,o.msg_id -- 报文编号
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
from ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_bk o
    left join ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_digit_curr_agt_info_h;
--alter table ${iml_schema}.agt_digit_curr_agt_info_h truncate partition for ('mpcsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_digit_curr_agt_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mpcsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_digit_curr_agt_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_digit_curr_agt_info_h modify partition p_mpcsf1 
add subpartition p_mpcsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_digit_curr_agt_info_h exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_cl;
alter table ${iml_schema}.agt_digit_curr_agt_info_h exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_digit_curr_agt_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_digit_curr_agt_info_h_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_digit_curr_agt_info_h', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
