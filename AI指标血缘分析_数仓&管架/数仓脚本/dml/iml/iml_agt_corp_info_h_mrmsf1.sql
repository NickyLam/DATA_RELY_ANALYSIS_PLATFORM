/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_corp_info_h_mrmsf1
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
alter table ${iml_schema}.agt_corp_info_h add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mrmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_corp_info_h_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_corp_info_h partition for ('mrmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_corp_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.agt_corp_info_h_mrmsf1_op purge;
drop table ${iml_schema}.agt_corp_info_h_mrmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_corp_info_h_mrmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_corp_id -- 协议单位编号
    ,agt_corp_name -- 协议单位名称
    ,agt_corp_abbr -- 协议单位简称
    ,payfan_chn_id -- 代付渠道编号
    ,agency_id -- 代理商编号
    ,agt_corp_type_cd -- 协议单位类型代码
    ,belong_org_id -- 所属机构编号
    ,bus_lics_id -- 营业执照编号
    ,bus_lics_stop_valid_dt -- 营业执照截止有效日期
    ,lp_name -- 法人姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,e_mail -- 电子邮箱
    ,cotas_name -- 联系人名称
    ,cotas_cert_type_cd -- 联系人证件类型代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,zip_cd -- 邮政编码
    ,cotas_addr -- 联系人地址
    ,stl_acct_type_cd -- 结算账户类型代码
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_name -- 结算账户名称
    ,ghb_enter_acct_flg -- 本行入账标志
    ,open_bank_no -- 开户行行号
    ,open_bank_bank_name -- 开户行行名称
    ,open_acct_addr -- 开户地址
    ,agt_corp_status_cd -- 协议单位状态代码
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,add_dt -- 新增日期
    ,final_modif_dt -- 最后修改日期
    ,oper_teller_id -- 操作柜员编号
    ,sys_idf -- API系统标识
    ,adv_acct_type_cd -- 垫资账户类型代码
    ,adv_acct_id -- 垫资账户编号
    ,adv_acct_name -- 垫资账户名称
    ,agt_corp_lmt -- 协议单位额度
    ,sig_lmt -- 单笔限额
    ,used_lmt -- 已使用额度
    ,payfan_second_lmt -- 代付还款额度
    ,adv_amt -- 垫资金额
    ,last_use_lmt -- 上次使用额度
    ,st_msg_advise_mobile_no -- 短信通知手机号码
    ,st_msg_advise_name -- 短信通知姓名
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_corp_info_h partition for ('mrmsf1')
where 0=1
;

create table ${iml_schema}.agt_corp_info_h_mrmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_corp_info_h partition for ('mrmsf1') where 0=1;

create table ${iml_schema}.agt_corp_info_h_mrmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_corp_info_h partition for ('mrmsf1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_fund_info-1
insert into ${iml_schema}.agt_corp_info_h_mrmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_corp_id -- 协议单位编号
    ,agt_corp_name -- 协议单位名称
    ,agt_corp_abbr -- 协议单位简称
    ,payfan_chn_id -- 代付渠道编号
    ,agency_id -- 代理商编号
    ,agt_corp_type_cd -- 协议单位类型代码
    ,belong_org_id -- 所属机构编号
    ,bus_lics_id -- 营业执照编号
    ,bus_lics_stop_valid_dt -- 营业执照截止有效日期
    ,lp_name -- 法人姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,e_mail -- 电子邮箱
    ,cotas_name -- 联系人名称
    ,cotas_cert_type_cd -- 联系人证件类型代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,zip_cd -- 邮政编码
    ,cotas_addr -- 联系人地址
    ,stl_acct_type_cd -- 结算账户类型代码
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_name -- 结算账户名称
    ,ghb_enter_acct_flg -- 本行入账标志
    ,open_bank_no -- 开户行行号
    ,open_bank_bank_name -- 开户行行名称
    ,open_acct_addr -- 开户地址
    ,agt_corp_status_cd -- 协议单位状态代码
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,add_dt -- 新增日期
    ,final_modif_dt -- 最后修改日期
    ,oper_teller_id -- 操作柜员编号
    ,sys_idf -- API系统标识
    ,adv_acct_type_cd -- 垫资账户类型代码
    ,adv_acct_id -- 垫资账户编号
    ,adv_acct_name -- 垫资账户名称
    ,agt_corp_lmt -- 协议单位额度
    ,sig_lmt -- 单笔限额
    ,used_lmt -- 已使用额度
    ,payfan_second_lmt -- 代付还款额度
    ,adv_amt -- 垫资金额
    ,last_use_lmt -- 上次使用额度
    ,st_msg_advise_mobile_no -- 短信通知手机号码
    ,st_msg_advise_name -- 短信通知姓名
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300047'||P1.FUND_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.FUND_ID -- 协议单位编号
    ,P1.FUND_NAME -- 协议单位名称
    ,P1.FUND_SHORT_NAME -- 协议单位简称
    ,P1.CHANNEL_ID -- 代付渠道编号
    ,P1.AGENT_ID -- 代理商编号
    ,nvl(trim(P1.PRO_TYPE),'-') -- 协议单位类型代码
    ,P1.ACQ_INST_ID -- 所属机构编号
    ,P1.LICENCE_NO -- 营业执照编号
    ,${iml_schema}.timeformat_max2(P1.LICENCE_END_DATE) -- 营业执照截止有效日期
    ,P1.MANAGER -- 法人姓名
    ,nvl(trim(P1.ARTIF_CERTIF_TP),'0000') -- 证件类型代码
    ,P1.IDENTITY_NO -- 证件号码
    ,P1.MANAGER_TEL -- 手机号码
    ,P1.EMAIL -- 电子邮箱
    ,P1.CONTACT -- 联系人名称
    ,nvl(trim(P1.CONM_CERTIF_TP),'0000') -- 联系人证件类型代码
    ,P1.CONM_IDENTITY_NO -- 联系人证件号码
    ,P1.COMM_TEL -- 联系人电话号码
    ,P1.POST_CODE -- 邮政编码
    ,P1.COMM_ADDR -- 联系人地址
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.SETT_ACCOUNT_TYPE END -- 结算账户类型代码
    ,P1.SETT_ACCOUNT -- 结算账户编号
    ,P1.SETT_ACCOUNT_NAME -- 结算账户名称
    ,decode(trim(P1.ACCT_CHNL),'B','1','T','0','','-',P1.ACCT_CHNL） -- 本行入账标志
    ,P1.OPEN_BANK -- 开户行行号
    ,P1.OPEN_BANKNAME -- 开户行行名称
    ,P1.OPEN_ACCT_ADDR -- 开户地址
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.FUND_STATUS END -- 协议单位状态代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.RCV_ACCT_TYPE END -- 收款账户类型代码
    ,P1.RCV_ACCOUNT -- 收款账户编号
    ,P1.RCV_ACCOUNT_NAME -- 收款账户名称
    ,${iml_schema}.timeformat_min(P1.LICENCE_END_DATE) -- 新增日期
    ,${iml_schema}.timeformat_max2(P1.MODFIY_DATE) -- 最后修改日期
    ,P1.OPR_ID -- 操作柜员编号
    ,P1.API_ID -- API系统标识
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.CUSHION_ACCT_TYPE END -- 垫资账户类型代码
    ,P1.CUSHION_ACCT -- 垫资账户编号
    ,P1.CUSHION_ACCT_NAME -- 垫资账户名称
    ,P1.FUND_AMT -- 协议单位额度
    ,P1.SING_LIMIT -- 单笔限额
    ,P1.USED_AMT -- 已使用额度
    ,P1.TRAND_AMT -- 代付还款额度
    ,P1.CUSHION_AMT -- 垫资金额
    ,P1.LAST_USED_AMT -- 上次使用额度
    ,P1.SMS_PHONE -- 短信通知手机号码
    ,P1.SMS_NAME -- 短信通知姓名
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_fund_info' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_fund_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.SETT_ACCOUNT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_FUND_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'SETT_ACCOUNT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_CORP_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'STL_ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.FUND_STATUS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MRMS'
        AND R3.SRC_TAB_EN_NAME= 'MRMS_TBL_FUND_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'FUND_STATUS'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_CORP_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'AGT_CORP_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.RCV_ACCT_TYPE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MRMS'
        AND R4.SRC_TAB_EN_NAME= 'MRMS_TBL_FUND_INFO'
        AND R4.SRC_FIELD_EN_NAME= 'RCV_ACCT_TYPE'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_CORP_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'RECVBL_ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CUSHION_ACCT_TYPE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MRMS'
        AND R5.SRC_TAB_EN_NAME= 'MRMS_TBL_FUND_INFO'
        AND R5.SRC_FIELD_EN_NAME= 'CUSHION_ACCT_TYPE'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_CORP_INFO_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'ADV_ACCT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_corp_info_h_mrmsf1_tm 
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
        into ${iml_schema}.agt_corp_info_h_mrmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_corp_id -- 协议单位编号
    ,agt_corp_name -- 协议单位名称
    ,agt_corp_abbr -- 协议单位简称
    ,payfan_chn_id -- 代付渠道编号
    ,agency_id -- 代理商编号
    ,agt_corp_type_cd -- 协议单位类型代码
    ,belong_org_id -- 所属机构编号
    ,bus_lics_id -- 营业执照编号
    ,bus_lics_stop_valid_dt -- 营业执照截止有效日期
    ,lp_name -- 法人姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,e_mail -- 电子邮箱
    ,cotas_name -- 联系人名称
    ,cotas_cert_type_cd -- 联系人证件类型代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,zip_cd -- 邮政编码
    ,cotas_addr -- 联系人地址
    ,stl_acct_type_cd -- 结算账户类型代码
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_name -- 结算账户名称
    ,ghb_enter_acct_flg -- 本行入账标志
    ,open_bank_no -- 开户行行号
    ,open_bank_bank_name -- 开户行行名称
    ,open_acct_addr -- 开户地址
    ,agt_corp_status_cd -- 协议单位状态代码
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,add_dt -- 新增日期
    ,final_modif_dt -- 最后修改日期
    ,oper_teller_id -- 操作柜员编号
    ,sys_idf -- API系统标识
    ,adv_acct_type_cd -- 垫资账户类型代码
    ,adv_acct_id -- 垫资账户编号
    ,adv_acct_name -- 垫资账户名称
    ,agt_corp_lmt -- 协议单位额度
    ,sig_lmt -- 单笔限额
    ,used_lmt -- 已使用额度
    ,payfan_second_lmt -- 代付还款额度
    ,adv_amt -- 垫资金额
    ,last_use_lmt -- 上次使用额度
    ,st_msg_advise_mobile_no -- 短信通知手机号码
    ,st_msg_advise_name -- 短信通知姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_corp_info_h_mrmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_corp_id -- 协议单位编号
    ,agt_corp_name -- 协议单位名称
    ,agt_corp_abbr -- 协议单位简称
    ,payfan_chn_id -- 代付渠道编号
    ,agency_id -- 代理商编号
    ,agt_corp_type_cd -- 协议单位类型代码
    ,belong_org_id -- 所属机构编号
    ,bus_lics_id -- 营业执照编号
    ,bus_lics_stop_valid_dt -- 营业执照截止有效日期
    ,lp_name -- 法人姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,e_mail -- 电子邮箱
    ,cotas_name -- 联系人名称
    ,cotas_cert_type_cd -- 联系人证件类型代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,zip_cd -- 邮政编码
    ,cotas_addr -- 联系人地址
    ,stl_acct_type_cd -- 结算账户类型代码
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_name -- 结算账户名称
    ,ghb_enter_acct_flg -- 本行入账标志
    ,open_bank_no -- 开户行行号
    ,open_bank_bank_name -- 开户行行名称
    ,open_acct_addr -- 开户地址
    ,agt_corp_status_cd -- 协议单位状态代码
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,add_dt -- 新增日期
    ,final_modif_dt -- 最后修改日期
    ,oper_teller_id -- 操作柜员编号
    ,sys_idf -- API系统标识
    ,adv_acct_type_cd -- 垫资账户类型代码
    ,adv_acct_id -- 垫资账户编号
    ,adv_acct_name -- 垫资账户名称
    ,agt_corp_lmt -- 协议单位额度
    ,sig_lmt -- 单笔限额
    ,used_lmt -- 已使用额度
    ,payfan_second_lmt -- 代付还款额度
    ,adv_amt -- 垫资金额
    ,last_use_lmt -- 上次使用额度
    ,st_msg_advise_mobile_no -- 短信通知手机号码
    ,st_msg_advise_name -- 短信通知姓名
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
    ,nvl(n.agt_corp_id, o.agt_corp_id) as agt_corp_id -- 协议单位编号
    ,nvl(n.agt_corp_name, o.agt_corp_name) as agt_corp_name -- 协议单位名称
    ,nvl(n.agt_corp_abbr, o.agt_corp_abbr) as agt_corp_abbr -- 协议单位简称
    ,nvl(n.payfan_chn_id, o.payfan_chn_id) as payfan_chn_id -- 代付渠道编号
    ,nvl(n.agency_id, o.agency_id) as agency_id -- 代理商编号
    ,nvl(n.agt_corp_type_cd, o.agt_corp_type_cd) as agt_corp_type_cd -- 协议单位类型代码
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.bus_lics_id, o.bus_lics_id) as bus_lics_id -- 营业执照编号
    ,nvl(n.bus_lics_stop_valid_dt, o.bus_lics_stop_valid_dt) as bus_lics_stop_valid_dt -- 营业执照截止有效日期
    ,nvl(n.lp_name, o.lp_name) as lp_name -- 法人姓名
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.e_mail, o.e_mail) as e_mail -- 电子邮箱
    ,nvl(n.cotas_name, o.cotas_name) as cotas_name -- 联系人名称
    ,nvl(n.cotas_cert_type_cd, o.cotas_cert_type_cd) as cotas_cert_type_cd -- 联系人证件类型代码
    ,nvl(n.cotas_cert_no, o.cotas_cert_no) as cotas_cert_no -- 联系人证件号码
    ,nvl(n.cotas_tel_num, o.cotas_tel_num) as cotas_tel_num -- 联系人电话号码
    ,nvl(n.zip_cd, o.zip_cd) as zip_cd -- 邮政编码
    ,nvl(n.cotas_addr, o.cotas_addr) as cotas_addr -- 联系人地址
    ,nvl(n.stl_acct_type_cd, o.stl_acct_type_cd) as stl_acct_type_cd -- 结算账户类型代码
    ,nvl(n.stl_acct_id, o.stl_acct_id) as stl_acct_id -- 结算账户编号
    ,nvl(n.stl_acct_name, o.stl_acct_name) as stl_acct_name -- 结算账户名称
    ,nvl(n.ghb_enter_acct_flg, o.ghb_enter_acct_flg) as ghb_enter_acct_flg -- 本行入账标志
    ,nvl(n.open_bank_no, o.open_bank_no) as open_bank_no -- 开户行行号
    ,nvl(n.open_bank_bank_name, o.open_bank_bank_name) as open_bank_bank_name -- 开户行行名称
    ,nvl(n.open_acct_addr, o.open_acct_addr) as open_acct_addr -- 开户地址
    ,nvl(n.agt_corp_status_cd, o.agt_corp_status_cd) as agt_corp_status_cd -- 协议单位状态代码
    ,nvl(n.recvbl_acct_type_cd, o.recvbl_acct_type_cd) as recvbl_acct_type_cd -- 收款账户类型代码
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.recvbl_acct_name, o.recvbl_acct_name) as recvbl_acct_name -- 收款账户名称
    ,nvl(n.add_dt, o.add_dt) as add_dt -- 新增日期
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 操作柜员编号
    ,nvl(n.sys_idf, o.sys_idf) as sys_idf -- API系统标识
    ,nvl(n.adv_acct_type_cd, o.adv_acct_type_cd) as adv_acct_type_cd -- 垫资账户类型代码
    ,nvl(n.adv_acct_id, o.adv_acct_id) as adv_acct_id -- 垫资账户编号
    ,nvl(n.adv_acct_name, o.adv_acct_name) as adv_acct_name -- 垫资账户名称
    ,nvl(n.agt_corp_lmt, o.agt_corp_lmt) as agt_corp_lmt -- 协议单位额度
    ,nvl(n.sig_lmt, o.sig_lmt) as sig_lmt -- 单笔限额
    ,nvl(n.used_lmt, o.used_lmt) as used_lmt -- 已使用额度
    ,nvl(n.payfan_second_lmt, o.payfan_second_lmt) as payfan_second_lmt -- 代付还款额度
    ,nvl(n.adv_amt, o.adv_amt) as adv_amt -- 垫资金额
    ,nvl(n.last_use_lmt, o.last_use_lmt) as last_use_lmt -- 上次使用额度
    ,nvl(n.st_msg_advise_mobile_no, o.st_msg_advise_mobile_no) as st_msg_advise_mobile_no -- 短信通知手机号码
    ,nvl(n.st_msg_advise_name, o.st_msg_advise_name) as st_msg_advise_name -- 短信通知姓名
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
from ${iml_schema}.agt_corp_info_h_mrmsf1_tm n
    full join (select * from ${iml_schema}.agt_corp_info_h_mrmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.agt_corp_id <> n.agt_corp_id
        or o.agt_corp_name <> n.agt_corp_name
        or o.agt_corp_abbr <> n.agt_corp_abbr
        or o.payfan_chn_id <> n.payfan_chn_id
        or o.agency_id <> n.agency_id
        or o.agt_corp_type_cd <> n.agt_corp_type_cd
        or o.belong_org_id <> n.belong_org_id
        or o.bus_lics_id <> n.bus_lics_id
        or o.bus_lics_stop_valid_dt <> n.bus_lics_stop_valid_dt
        or o.lp_name <> n.lp_name
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.mobile_no <> n.mobile_no
        or o.e_mail <> n.e_mail
        or o.cotas_name <> n.cotas_name
        or o.cotas_cert_type_cd <> n.cotas_cert_type_cd
        or o.cotas_cert_no <> n.cotas_cert_no
        or o.cotas_tel_num <> n.cotas_tel_num
        or o.zip_cd <> n.zip_cd
        or o.cotas_addr <> n.cotas_addr
        or o.stl_acct_type_cd <> n.stl_acct_type_cd
        or o.stl_acct_id <> n.stl_acct_id
        or o.stl_acct_name <> n.stl_acct_name
        or o.ghb_enter_acct_flg <> n.ghb_enter_acct_flg
        or o.open_bank_no <> n.open_bank_no
        or o.open_bank_bank_name <> n.open_bank_bank_name
        or o.open_acct_addr <> n.open_acct_addr
        or o.agt_corp_status_cd <> n.agt_corp_status_cd
        or o.recvbl_acct_type_cd <> n.recvbl_acct_type_cd
        or o.recvbl_acct_id <> n.recvbl_acct_id
        or o.recvbl_acct_name <> n.recvbl_acct_name
        or o.add_dt <> n.add_dt
        or o.final_modif_dt <> n.final_modif_dt
        or o.oper_teller_id <> n.oper_teller_id
        or o.sys_idf <> n.sys_idf
        or o.adv_acct_type_cd <> n.adv_acct_type_cd
        or o.adv_acct_id <> n.adv_acct_id
        or o.adv_acct_name <> n.adv_acct_name
        or o.agt_corp_lmt <> n.agt_corp_lmt
        or o.sig_lmt <> n.sig_lmt
        or o.used_lmt <> n.used_lmt
        or o.payfan_second_lmt <> n.payfan_second_lmt
        or o.adv_amt <> n.adv_amt
        or o.last_use_lmt <> n.last_use_lmt
        or o.st_msg_advise_mobile_no <> n.st_msg_advise_mobile_no
        or o.st_msg_advise_name <> n.st_msg_advise_name
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_corp_info_h_mrmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_corp_id -- 协议单位编号
    ,agt_corp_name -- 协议单位名称
    ,agt_corp_abbr -- 协议单位简称
    ,payfan_chn_id -- 代付渠道编号
    ,agency_id -- 代理商编号
    ,agt_corp_type_cd -- 协议单位类型代码
    ,belong_org_id -- 所属机构编号
    ,bus_lics_id -- 营业执照编号
    ,bus_lics_stop_valid_dt -- 营业执照截止有效日期
    ,lp_name -- 法人姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,e_mail -- 电子邮箱
    ,cotas_name -- 联系人名称
    ,cotas_cert_type_cd -- 联系人证件类型代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,zip_cd -- 邮政编码
    ,cotas_addr -- 联系人地址
    ,stl_acct_type_cd -- 结算账户类型代码
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_name -- 结算账户名称
    ,ghb_enter_acct_flg -- 本行入账标志
    ,open_bank_no -- 开户行行号
    ,open_bank_bank_name -- 开户行行名称
    ,open_acct_addr -- 开户地址
    ,agt_corp_status_cd -- 协议单位状态代码
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,add_dt -- 新增日期
    ,final_modif_dt -- 最后修改日期
    ,oper_teller_id -- 操作柜员编号
    ,sys_idf -- API系统标识
    ,adv_acct_type_cd -- 垫资账户类型代码
    ,adv_acct_id -- 垫资账户编号
    ,adv_acct_name -- 垫资账户名称
    ,agt_corp_lmt -- 协议单位额度
    ,sig_lmt -- 单笔限额
    ,used_lmt -- 已使用额度
    ,payfan_second_lmt -- 代付还款额度
    ,adv_amt -- 垫资金额
    ,last_use_lmt -- 上次使用额度
    ,st_msg_advise_mobile_no -- 短信通知手机号码
    ,st_msg_advise_name -- 短信通知姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_corp_info_h_mrmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_corp_id -- 协议单位编号
    ,agt_corp_name -- 协议单位名称
    ,agt_corp_abbr -- 协议单位简称
    ,payfan_chn_id -- 代付渠道编号
    ,agency_id -- 代理商编号
    ,agt_corp_type_cd -- 协议单位类型代码
    ,belong_org_id -- 所属机构编号
    ,bus_lics_id -- 营业执照编号
    ,bus_lics_stop_valid_dt -- 营业执照截止有效日期
    ,lp_name -- 法人姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,e_mail -- 电子邮箱
    ,cotas_name -- 联系人名称
    ,cotas_cert_type_cd -- 联系人证件类型代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,zip_cd -- 邮政编码
    ,cotas_addr -- 联系人地址
    ,stl_acct_type_cd -- 结算账户类型代码
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_name -- 结算账户名称
    ,ghb_enter_acct_flg -- 本行入账标志
    ,open_bank_no -- 开户行行号
    ,open_bank_bank_name -- 开户行行名称
    ,open_acct_addr -- 开户地址
    ,agt_corp_status_cd -- 协议单位状态代码
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,add_dt -- 新增日期
    ,final_modif_dt -- 最后修改日期
    ,oper_teller_id -- 操作柜员编号
    ,sys_idf -- API系统标识
    ,adv_acct_type_cd -- 垫资账户类型代码
    ,adv_acct_id -- 垫资账户编号
    ,adv_acct_name -- 垫资账户名称
    ,agt_corp_lmt -- 协议单位额度
    ,sig_lmt -- 单笔限额
    ,used_lmt -- 已使用额度
    ,payfan_second_lmt -- 代付还款额度
    ,adv_amt -- 垫资金额
    ,last_use_lmt -- 上次使用额度
    ,st_msg_advise_mobile_no -- 短信通知手机号码
    ,st_msg_advise_name -- 短信通知姓名
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
    ,o.agt_corp_id -- 协议单位编号
    ,o.agt_corp_name -- 协议单位名称
    ,o.agt_corp_abbr -- 协议单位简称
    ,o.payfan_chn_id -- 代付渠道编号
    ,o.agency_id -- 代理商编号
    ,o.agt_corp_type_cd -- 协议单位类型代码
    ,o.belong_org_id -- 所属机构编号
    ,o.bus_lics_id -- 营业执照编号
    ,o.bus_lics_stop_valid_dt -- 营业执照截止有效日期
    ,o.lp_name -- 法人姓名
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.mobile_no -- 手机号码
    ,o.e_mail -- 电子邮箱
    ,o.cotas_name -- 联系人名称
    ,o.cotas_cert_type_cd -- 联系人证件类型代码
    ,o.cotas_cert_no -- 联系人证件号码
    ,o.cotas_tel_num -- 联系人电话号码
    ,o.zip_cd -- 邮政编码
    ,o.cotas_addr -- 联系人地址
    ,o.stl_acct_type_cd -- 结算账户类型代码
    ,o.stl_acct_id -- 结算账户编号
    ,o.stl_acct_name -- 结算账户名称
    ,o.ghb_enter_acct_flg -- 本行入账标志
    ,o.open_bank_no -- 开户行行号
    ,o.open_bank_bank_name -- 开户行行名称
    ,o.open_acct_addr -- 开户地址
    ,o.agt_corp_status_cd -- 协议单位状态代码
    ,o.recvbl_acct_type_cd -- 收款账户类型代码
    ,o.recvbl_acct_id -- 收款账户编号
    ,o.recvbl_acct_name -- 收款账户名称
    ,o.add_dt -- 新增日期
    ,o.final_modif_dt -- 最后修改日期
    ,o.oper_teller_id -- 操作柜员编号
    ,o.sys_idf -- API系统标识
    ,o.adv_acct_type_cd -- 垫资账户类型代码
    ,o.adv_acct_id -- 垫资账户编号
    ,o.adv_acct_name -- 垫资账户名称
    ,o.agt_corp_lmt -- 协议单位额度
    ,o.sig_lmt -- 单笔限额
    ,o.used_lmt -- 已使用额度
    ,o.payfan_second_lmt -- 代付还款额度
    ,o.adv_amt -- 垫资金额
    ,o.last_use_lmt -- 上次使用额度
    ,o.st_msg_advise_mobile_no -- 短信通知手机号码
    ,o.st_msg_advise_name -- 短信通知姓名
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
from ${iml_schema}.agt_corp_info_h_mrmsf1_bk o
    left join ${iml_schema}.agt_corp_info_h_mrmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_corp_info_h_mrmsf1_cl d
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
--truncate table ${iml_schema}.agt_corp_info_h;
--alter table ${iml_schema}.agt_corp_info_h truncate partition for ('mrmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_corp_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mrmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_corp_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_corp_info_h modify partition p_mrmsf1 
add subpartition p_mrmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_corp_info_h exchange subpartition p_mrmsf1_${batch_date} with table ${iml_schema}.agt_corp_info_h_mrmsf1_cl;
alter table ${iml_schema}.agt_corp_info_h exchange subpartition p_mrmsf1_20991231 with table ${iml_schema}.agt_corp_info_h_mrmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_corp_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_corp_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.agt_corp_info_h_mrmsf1_op purge;
drop table ${iml_schema}.agt_corp_info_h_mrmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_corp_info_h_mrmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_corp_info_h', partname => 'p_mrmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
