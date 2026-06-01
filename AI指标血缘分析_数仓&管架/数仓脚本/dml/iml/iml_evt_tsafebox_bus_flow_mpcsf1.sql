/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_tsafebox_bus_flow_mpcsf1
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
alter table ${iml_schema}.evt_tsafebox_bus_flow add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_tsafebox_bus_flow partition for ('mpcsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_tm purge;
drop table ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_op purge;
drop table ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,safe_box_id -- 保管箱编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,pay_acct_id -- 付款账户编号
    ,pay_sub_acct_num -- 付款子账号
    ,payer_name -- 付款人名称
    ,payer_prod_id -- 付款方产品编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_sub_acct_num -- 收款子账号
    ,recvbl_acct_name -- 收款账户名称
    ,recver_prod_id -- 收款方产品编号
    ,margin -- 押金
    ,curr_cd -- 币种代码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_id -- 凭证编号
    ,vouch_invalid_dt -- 凭证失效日期
    ,cap_src_cd -- 资金来源代码
    ,unpacker_9elmnt -- 开箱人9要素
    ,unpacker_20elmnt -- 开箱人20要素
    ,unpacker_open_acct_vrfction_pass_flg -- 开箱人开户核查通过标志
    ,unpacker_kyc_pass_flg -- 开箱人KYC核查通过标志
    ,unpacker_anti_mon_lau_vrfction_pass_flg -- 开箱人反洗钱核查通过标志
    ,unpacker_netw_vrfction_pass_flg -- 开箱人联网核查通过标志
    ,co_sign_unpacker_9elmnt -- 联名开箱人9要素
    ,co_sign_unpacker_open_acct_vrfction_pass_flg -- 联名开箱人开户核查通过标志
    ,co_sign_unpacker_kyc_pass_flg -- 联名开箱人KYC核查通过标志
    ,co_sign_unpacker_anti_mon_lau_vrfction_pass_flg -- 联名开箱人反洗钱核查通过标志
    ,co_sign_unpacker_netw_vrfction_pass_flg -- 联名开箱人联网核查通过标志
    ,agent_4_elmnt -- 代理人4要素
    ,agent_open_acct_vrfction_pass_flg -- 代理人开户核查通过标志
    ,agent_kyc_pass_flg -- 代理人KYC核查通过标志
    ,agent_anti_mon_lau_vrfction_pass_flg -- 代理人反洗钱核查通过标志
    ,agent_netw_vrfction_pass_flg -- 代理人联网核查通过标志
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,chn_id -- 渠道编号
    ,org_id -- 机构编号
    ,onacct_and_wrtoff_flow_num -- 挂销流水号
    ,trdpty_tran_code -- 第三方交易码
    ,core_flow_num -- 核心流水号
    ,core_dt -- 核心日期
    ,entry_sub_flow_num -- 记账子流水号
    ,revs_flg -- 冲正标志
    ,revs_ova_flow_num -- 冲正全局流水号
    ,revs_cnt -- 冲正次数
    ,revs_fail_remark -- 冲正失败备注
    ,reply_cd -- 应答码
    ,reply_info -- 应答信息
    ,final_update_dt -- 最后更新日期
    ,rent_safebox_status_cd -- 租箱状态代码
    ,rent_safebox_dt -- 租箱日期
    ,rent_safebox_exp_dt -- 租箱到期日期
    ,proc_teller_id -- 处理柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_tsafebox_bus_flow partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_tsafebox_bus_flow partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_tsafebox_bus_flow partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a20tsafeboxinf-1
insert into ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,safe_box_id -- 保管箱编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,pay_acct_id -- 付款账户编号
    ,pay_sub_acct_num -- 付款子账号
    ,payer_name -- 付款人名称
    ,payer_prod_id -- 付款方产品编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_sub_acct_num -- 收款子账号
    ,recvbl_acct_name -- 收款账户名称
    ,recver_prod_id -- 收款方产品编号
    ,margin -- 押金
    ,curr_cd -- 币种代码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_id -- 凭证编号
    ,vouch_invalid_dt -- 凭证失效日期
    ,cap_src_cd -- 资金来源代码
    ,unpacker_9elmnt -- 开箱人9要素
    ,unpacker_20elmnt -- 开箱人20要素
    ,unpacker_open_acct_vrfction_pass_flg -- 开箱人开户核查通过标志
    ,unpacker_kyc_pass_flg -- 开箱人KYC核查通过标志
    ,unpacker_anti_mon_lau_vrfction_pass_flg -- 开箱人反洗钱核查通过标志
    ,unpacker_netw_vrfction_pass_flg -- 开箱人联网核查通过标志
    ,co_sign_unpacker_9elmnt -- 联名开箱人9要素
    ,co_sign_unpacker_open_acct_vrfction_pass_flg -- 联名开箱人开户核查通过标志
    ,co_sign_unpacker_kyc_pass_flg -- 联名开箱人KYC核查通过标志
    ,co_sign_unpacker_anti_mon_lau_vrfction_pass_flg -- 联名开箱人反洗钱核查通过标志
    ,co_sign_unpacker_netw_vrfction_pass_flg -- 联名开箱人联网核查通过标志
    ,agent_4_elmnt -- 代理人4要素
    ,agent_open_acct_vrfction_pass_flg -- 代理人开户核查通过标志
    ,agent_kyc_pass_flg -- 代理人KYC核查通过标志
    ,agent_anti_mon_lau_vrfction_pass_flg -- 代理人反洗钱核查通过标志
    ,agent_netw_vrfction_pass_flg -- 代理人联网核查通过标志
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,chn_id -- 渠道编号
    ,org_id -- 机构编号
    ,onacct_and_wrtoff_flow_num -- 挂销流水号
    ,trdpty_tran_code -- 第三方交易码
    ,core_flow_num -- 核心流水号
    ,core_dt -- 核心日期
    ,entry_sub_flow_num -- 记账子流水号
    ,revs_flg -- 冲正标志
    ,revs_ova_flow_num -- 冲正全局流水号
    ,revs_cnt -- 冲正次数
    ,revs_fail_remark -- 冲正失败备注
    ,reply_cd -- 应答码
    ,reply_info -- 应答信息
    ,final_update_dt -- 最后更新日期
    ,rent_safebox_status_cd -- 租箱状态代码
    ,rent_safebox_dt -- 租箱日期
    ,rent_safebox_exp_dt -- 租箱到期日期
    ,proc_teller_id -- 处理柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401034'||P1.MAINSEQ||P1.TRANSDT -- 事件编号
    ,'9999' -- 法人编号
    ,P1.MAINSEQ -- 中台流水号
    ,${iml_schema}.dateformat_max2(P1.TRANSTM) -- 交易日期
    ,P1.FNTTRNCD -- 交易码
    ,nvl(trim(P1.STATUS),'-') -- 交易状态代码
    ,P1.SAFEBOX -- 保管箱编号
    ,P1.CUSTNO -- 客户编号
    ,P1.CUSTNM -- 客户名称
    ,nvl(trim(P1.CUSTTYPE),'-') -- 客户类型代码
    ,nvl(trim(P1.IDTYPE),'0000') -- 证件类型代码
    ,P1.IDNO -- 证件号码
    ,P1.PAYACCT -- 付款账户编号
    ,P1.SUBSEQNO -- 付款子账号
    ,P1.PAYNAME -- 付款人名称
    ,P1.PAYPRODTYPE -- 付款方产品编号
    ,P1.INCOACCT -- 收款账户编号
    ,P1.INCOSUBSEQNO -- 收款子账号
    ,P1.INCONAME -- 收款账户名称
    ,P1.INCOPRODTYPE -- 收款方产品编号
    ,to_number(nvl(trim(P1.DEPOSIT),0)) -- 押金
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,nvl(trim(P1.DOCTYPE),'000') -- 凭证类型代码
    ,P1.DOCNO -- 凭证编号
    ,${iml_schema}.dateformat_max2(P1.DRAFTDATE) -- 凭证失效日期
    ,nvl(trim(P1.FUNDSOURCE),'-') -- 资金来源代码
    ,P1.OPNRS_9_ELMNT -- 开箱人9要素
    ,P1.OPNRS_20_ELMNT -- 开箱人20要素
    ,decode(P1.OPENER_OPNACCTCHK,' ','-','1','1','2','0',P1.OPENER_OPNACCTCHK) -- 开箱人开户核查通过标志
    ,decode(P1.OPENER_KYCCHK,' ','-','1','1','2','0',P1.OPENER_KYCCHK) -- 开箱人KYC核查通过标志
    ,decode(P1.OPENER_FXQCHK,' ','-','1','1','2','0',P1.OPENER_FXQCHK) -- 开箱人反洗钱核查通过标志
    ,decode(P1.OPENER_LWHCCHK,' ','-','1','1','2','0',P1.OPENER_LWHCCHK) -- 开箱人联网核查通过标志
    ,P1.CO_OPNRS_9_ELMNT -- 联名开箱人9要素
    ,decode(P1.CO_OPENER_OPNACCTCHK,' ','-','1','1','2','0',P1.CO_OPENER_OPNACCTCHK) -- 联名开箱人开户核查通过标志
    ,decode(P1.CO_OPENER_KYCCHK,' ','-','1','1','2','0',P1.CO_OPENER_KYCCHK) -- 联名开箱人KYC核查通过标志
    ,decode(P1.CO_OPENER_FXQCHK,' ','-','1','1','2','0',P1.CO_OPENER_FXQCHK) -- 联名开箱人反洗钱核查通过标志
    ,decode(P1.CO_OPENER_LWHCCHK,' ','-','1','1','2','0',P1.CO_OPENER_LWHCCHK) -- 联名开箱人联网核查通过标志
    ,P1.AGENT_9_ELMNT -- 代理人4要素
    ,decode(P1.AGENT_OPNACCTCHK,' ','-','1','1','2','0',P1.AGENT_OPNACCTCHK) -- 代理人开户核查通过标志
    ,decode(P1.AGENT_KYCCHK,' ','-','1','1','2','0',P1.AGENT_KYCCHK) -- 代理人KYC核查通过标志
    ,decode(P1.AGENT_FXQCHK,' ','-','1','1','2','0',P1.AGENT_FXQCHK) -- 代理人反洗钱核查通过标志
    ,decode(P1.AGENT_LWHCCHK,' ','-','1','1','2','0',P1.AGENT_LWHCCHK) -- 代理人联网核查通过标志
    ,P1.GLOB_SEQ_NUM -- 全局流水号
    ,P1.UNIQUE_SEQ_NUM -- 业务流水号
    ,nvl(trim(P1.CHN_ID),'0000') -- 渠道编号
    ,P1.BRCNO -- 机构编号
    ,P1.HANGSEQNO -- 挂销流水号
    ,P1.DSTTRNCD -- 第三方交易码
    ,P1.HOSTSEQNO -- 核心流水号
    ,${iml_schema}.dateformat_max2(P1.HOSTDT) -- 核心日期
    ,P1.DATAID -- 记账子流水号
    ,nvl(trim(P1.UCSTAT),'-') -- 冲正标志
    ,P1.UC_GLOB_SEQ_NUM -- 冲正全局流水号
    ,P1.UC_TIMES -- 冲正次数
    ,P1.UC_ERR_MSG -- 冲正失败备注
    ,P1.RSPCD -- 应答码
    ,P1.RSPMSG -- 应答信息
    ,${iml_schema}.dateformat_max2(P1.UPD_TIME) -- 最后更新日期
    ,nvl(trim(P1.RENTBOXSTATUS),'-') -- 租箱状态代码
    ,${iml_schema}.dateformat_max2(P1.RENTBOXDATE) -- 租箱日期
    ,${iml_schema}.dateformat_max2(P1.RENTBOXENDDT) -- 租箱到期日期
    ,P1.TLRNO -- 处理柜员编号
    ,P1.AUTHTLRNO -- 授权柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a20tsafeboxinf' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a20tsafeboxinf p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_tm 
  	                                group by 
  	                                        evt_id
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
        into ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,safe_box_id -- 保管箱编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,pay_acct_id -- 付款账户编号
    ,pay_sub_acct_num -- 付款子账号
    ,payer_name -- 付款人名称
    ,payer_prod_id -- 付款方产品编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_sub_acct_num -- 收款子账号
    ,recvbl_acct_name -- 收款账户名称
    ,recver_prod_id -- 收款方产品编号
    ,margin -- 押金
    ,curr_cd -- 币种代码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_id -- 凭证编号
    ,vouch_invalid_dt -- 凭证失效日期
    ,cap_src_cd -- 资金来源代码
    ,unpacker_9elmnt -- 开箱人9要素
    ,unpacker_20elmnt -- 开箱人20要素
    ,unpacker_open_acct_vrfction_pass_flg -- 开箱人开户核查通过标志
    ,unpacker_kyc_pass_flg -- 开箱人KYC核查通过标志
    ,unpacker_anti_mon_lau_vrfction_pass_flg -- 开箱人反洗钱核查通过标志
    ,unpacker_netw_vrfction_pass_flg -- 开箱人联网核查通过标志
    ,co_sign_unpacker_9elmnt -- 联名开箱人9要素
    ,co_sign_unpacker_open_acct_vrfction_pass_flg -- 联名开箱人开户核查通过标志
    ,co_sign_unpacker_kyc_pass_flg -- 联名开箱人KYC核查通过标志
    ,co_sign_unpacker_anti_mon_lau_vrfction_pass_flg -- 联名开箱人反洗钱核查通过标志
    ,co_sign_unpacker_netw_vrfction_pass_flg -- 联名开箱人联网核查通过标志
    ,agent_4_elmnt -- 代理人4要素
    ,agent_open_acct_vrfction_pass_flg -- 代理人开户核查通过标志
    ,agent_kyc_pass_flg -- 代理人KYC核查通过标志
    ,agent_anti_mon_lau_vrfction_pass_flg -- 代理人反洗钱核查通过标志
    ,agent_netw_vrfction_pass_flg -- 代理人联网核查通过标志
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,chn_id -- 渠道编号
    ,org_id -- 机构编号
    ,onacct_and_wrtoff_flow_num -- 挂销流水号
    ,trdpty_tran_code -- 第三方交易码
    ,core_flow_num -- 核心流水号
    ,core_dt -- 核心日期
    ,entry_sub_flow_num -- 记账子流水号
    ,revs_flg -- 冲正标志
    ,revs_ova_flow_num -- 冲正全局流水号
    ,revs_cnt -- 冲正次数
    ,revs_fail_remark -- 冲正失败备注
    ,reply_cd -- 应答码
    ,reply_info -- 应答信息
    ,final_update_dt -- 最后更新日期
    ,rent_safebox_status_cd -- 租箱状态代码
    ,rent_safebox_dt -- 租箱日期
    ,rent_safebox_exp_dt -- 租箱到期日期
    ,proc_teller_id -- 处理柜员编号
    ,auth_teller_id -- 授权柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,safe_box_id -- 保管箱编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,pay_acct_id -- 付款账户编号
    ,pay_sub_acct_num -- 付款子账号
    ,payer_name -- 付款人名称
    ,payer_prod_id -- 付款方产品编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_sub_acct_num -- 收款子账号
    ,recvbl_acct_name -- 收款账户名称
    ,recver_prod_id -- 收款方产品编号
    ,margin -- 押金
    ,curr_cd -- 币种代码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_id -- 凭证编号
    ,vouch_invalid_dt -- 凭证失效日期
    ,cap_src_cd -- 资金来源代码
    ,unpacker_9elmnt -- 开箱人9要素
    ,unpacker_20elmnt -- 开箱人20要素
    ,unpacker_open_acct_vrfction_pass_flg -- 开箱人开户核查通过标志
    ,unpacker_kyc_pass_flg -- 开箱人KYC核查通过标志
    ,unpacker_anti_mon_lau_vrfction_pass_flg -- 开箱人反洗钱核查通过标志
    ,unpacker_netw_vrfction_pass_flg -- 开箱人联网核查通过标志
    ,co_sign_unpacker_9elmnt -- 联名开箱人9要素
    ,co_sign_unpacker_open_acct_vrfction_pass_flg -- 联名开箱人开户核查通过标志
    ,co_sign_unpacker_kyc_pass_flg -- 联名开箱人KYC核查通过标志
    ,co_sign_unpacker_anti_mon_lau_vrfction_pass_flg -- 联名开箱人反洗钱核查通过标志
    ,co_sign_unpacker_netw_vrfction_pass_flg -- 联名开箱人联网核查通过标志
    ,agent_4_elmnt -- 代理人4要素
    ,agent_open_acct_vrfction_pass_flg -- 代理人开户核查通过标志
    ,agent_kyc_pass_flg -- 代理人KYC核查通过标志
    ,agent_anti_mon_lau_vrfction_pass_flg -- 代理人反洗钱核查通过标志
    ,agent_netw_vrfction_pass_flg -- 代理人联网核查通过标志
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,chn_id -- 渠道编号
    ,org_id -- 机构编号
    ,onacct_and_wrtoff_flow_num -- 挂销流水号
    ,trdpty_tran_code -- 第三方交易码
    ,core_flow_num -- 核心流水号
    ,core_dt -- 核心日期
    ,entry_sub_flow_num -- 记账子流水号
    ,revs_flg -- 冲正标志
    ,revs_ova_flow_num -- 冲正全局流水号
    ,revs_cnt -- 冲正次数
    ,revs_fail_remark -- 冲正失败备注
    ,reply_cd -- 应答码
    ,reply_info -- 应答信息
    ,final_update_dt -- 最后更新日期
    ,rent_safebox_status_cd -- 租箱状态代码
    ,rent_safebox_dt -- 租箱日期
    ,rent_safebox_exp_dt -- 租箱到期日期
    ,proc_teller_id -- 处理柜员编号
    ,auth_teller_id -- 授权柜员编号
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
    ,nvl(n.midgrod_flow_num, o.midgrod_flow_num) as midgrod_flow_num -- 中台流水号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.safe_box_id, o.safe_box_id) as safe_box_id -- 保管箱编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.pay_acct_id, o.pay_acct_id) as pay_acct_id -- 付款账户编号
    ,nvl(n.pay_sub_acct_num, o.pay_sub_acct_num) as pay_sub_acct_num -- 付款子账号
    ,nvl(n.payer_name, o.payer_name) as payer_name -- 付款人名称
    ,nvl(n.payer_prod_id, o.payer_prod_id) as payer_prod_id -- 付款方产品编号
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.recvbl_sub_acct_num, o.recvbl_sub_acct_num) as recvbl_sub_acct_num -- 收款子账号
    ,nvl(n.recvbl_acct_name, o.recvbl_acct_name) as recvbl_acct_name -- 收款账户名称
    ,nvl(n.recver_prod_id, o.recver_prod_id) as recver_prod_id -- 收款方产品编号
    ,nvl(n.margin, o.margin) as margin -- 押金
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.vouch_type_cd, o.vouch_type_cd) as vouch_type_cd -- 凭证类型代码
    ,nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.vouch_invalid_dt, o.vouch_invalid_dt) as vouch_invalid_dt -- 凭证失效日期
    ,nvl(n.cap_src_cd, o.cap_src_cd) as cap_src_cd -- 资金来源代码
    ,nvl(n.unpacker_9elmnt, o.unpacker_9elmnt) as unpacker_9elmnt -- 开箱人9要素
    ,nvl(n.unpacker_20elmnt, o.unpacker_20elmnt) as unpacker_20elmnt -- 开箱人20要素
    ,nvl(n.unpacker_open_acct_vrfction_pass_flg, o.unpacker_open_acct_vrfction_pass_flg) as unpacker_open_acct_vrfction_pass_flg -- 开箱人开户核查通过标志
    ,nvl(n.unpacker_kyc_pass_flg, o.unpacker_kyc_pass_flg) as unpacker_kyc_pass_flg -- 开箱人KYC核查通过标志
    ,nvl(n.unpacker_anti_mon_lau_vrfction_pass_flg, o.unpacker_anti_mon_lau_vrfction_pass_flg) as unpacker_anti_mon_lau_vrfction_pass_flg -- 开箱人反洗钱核查通过标志
    ,nvl(n.unpacker_netw_vrfction_pass_flg, o.unpacker_netw_vrfction_pass_flg) as unpacker_netw_vrfction_pass_flg -- 开箱人联网核查通过标志
    ,nvl(n.co_sign_unpacker_9elmnt, o.co_sign_unpacker_9elmnt) as co_sign_unpacker_9elmnt -- 联名开箱人9要素
    ,nvl(n.co_sign_unpacker_open_acct_vrfction_pass_flg, o.co_sign_unpacker_open_acct_vrfction_pass_flg) as co_sign_unpacker_open_acct_vrfction_pass_flg -- 联名开箱人开户核查通过标志
    ,nvl(n.co_sign_unpacker_kyc_pass_flg, o.co_sign_unpacker_kyc_pass_flg) as co_sign_unpacker_kyc_pass_flg -- 联名开箱人KYC核查通过标志
    ,nvl(n.co_sign_unpacker_anti_mon_lau_vrfction_pass_flg, o.co_sign_unpacker_anti_mon_lau_vrfction_pass_flg) as co_sign_unpacker_anti_mon_lau_vrfction_pass_flg -- 联名开箱人反洗钱核查通过标志
    ,nvl(n.co_sign_unpacker_netw_vrfction_pass_flg, o.co_sign_unpacker_netw_vrfction_pass_flg) as co_sign_unpacker_netw_vrfction_pass_flg -- 联名开箱人联网核查通过标志
    ,nvl(n.agent_4_elmnt, o.agent_4_elmnt) as agent_4_elmnt -- 代理人4要素
    ,nvl(n.agent_open_acct_vrfction_pass_flg, o.agent_open_acct_vrfction_pass_flg) as agent_open_acct_vrfction_pass_flg -- 代理人开户核查通过标志
    ,nvl(n.agent_kyc_pass_flg, o.agent_kyc_pass_flg) as agent_kyc_pass_flg -- 代理人KYC核查通过标志
    ,nvl(n.agent_anti_mon_lau_vrfction_pass_flg, o.agent_anti_mon_lau_vrfction_pass_flg) as agent_anti_mon_lau_vrfction_pass_flg -- 代理人反洗钱核查通过标志
    ,nvl(n.agent_netw_vrfction_pass_flg, o.agent_netw_vrfction_pass_flg) as agent_netw_vrfction_pass_flg -- 代理人联网核查通过标志
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.bus_flow_num, o.bus_flow_num) as bus_flow_num -- 业务流水号
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.onacct_and_wrtoff_flow_num, o.onacct_and_wrtoff_flow_num) as onacct_and_wrtoff_flow_num -- 挂销流水号
    ,nvl(n.trdpty_tran_code, o.trdpty_tran_code) as trdpty_tran_code -- 第三方交易码
    ,nvl(n.core_flow_num, o.core_flow_num) as core_flow_num -- 核心流水号
    ,nvl(n.core_dt, o.core_dt) as core_dt -- 核心日期
    ,nvl(n.entry_sub_flow_num, o.entry_sub_flow_num) as entry_sub_flow_num -- 记账子流水号
    ,nvl(n.revs_flg, o.revs_flg) as revs_flg -- 冲正标志
    ,nvl(n.revs_ova_flow_num, o.revs_ova_flow_num) as revs_ova_flow_num -- 冲正全局流水号
    ,nvl(n.revs_cnt, o.revs_cnt) as revs_cnt -- 冲正次数
    ,nvl(n.revs_fail_remark, o.revs_fail_remark) as revs_fail_remark -- 冲正失败备注
    ,nvl(n.reply_cd, o.reply_cd) as reply_cd -- 应答码
    ,nvl(n.reply_info, o.reply_info) as reply_info -- 应答信息
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,nvl(n.rent_safebox_status_cd, o.rent_safebox_status_cd) as rent_safebox_status_cd -- 租箱状态代码
    ,nvl(n.rent_safebox_dt, o.rent_safebox_dt) as rent_safebox_dt -- 租箱日期
    ,nvl(n.rent_safebox_exp_dt, o.rent_safebox_exp_dt) as rent_safebox_exp_dt -- 租箱到期日期
    ,nvl(n.proc_teller_id, o.proc_teller_id) as proc_teller_id -- 处理柜员编号
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_tm n
    full join (select * from ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.midgrod_flow_num <> n.midgrod_flow_num
        or o.tran_dt <> n.tran_dt
        or o.tran_code <> n.tran_code
        or o.tran_status_cd <> n.tran_status_cd
        or o.safe_box_id <> n.safe_box_id
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cust_type_cd <> n.cust_type_cd
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.pay_acct_id <> n.pay_acct_id
        or o.pay_sub_acct_num <> n.pay_sub_acct_num
        or o.payer_name <> n.payer_name
        or o.payer_prod_id <> n.payer_prod_id
        or o.recvbl_acct_id <> n.recvbl_acct_id
        or o.recvbl_sub_acct_num <> n.recvbl_sub_acct_num
        or o.recvbl_acct_name <> n.recvbl_acct_name
        or o.recver_prod_id <> n.recver_prod_id
        or o.margin <> n.margin
        or o.curr_cd <> n.curr_cd
        or o.vouch_type_cd <> n.vouch_type_cd
        or o.vouch_id <> n.vouch_id
        or o.vouch_invalid_dt <> n.vouch_invalid_dt
        or o.cap_src_cd <> n.cap_src_cd
        or o.unpacker_9elmnt <> n.unpacker_9elmnt
        or o.unpacker_20elmnt <> n.unpacker_20elmnt
        or o.unpacker_open_acct_vrfction_pass_flg <> n.unpacker_open_acct_vrfction_pass_flg
        or o.unpacker_kyc_pass_flg <> n.unpacker_kyc_pass_flg
        or o.unpacker_anti_mon_lau_vrfction_pass_flg <> n.unpacker_anti_mon_lau_vrfction_pass_flg
        or o.unpacker_netw_vrfction_pass_flg <> n.unpacker_netw_vrfction_pass_flg
        or o.co_sign_unpacker_9elmnt <> n.co_sign_unpacker_9elmnt
        or o.co_sign_unpacker_open_acct_vrfction_pass_flg <> n.co_sign_unpacker_open_acct_vrfction_pass_flg
        or o.co_sign_unpacker_kyc_pass_flg <> n.co_sign_unpacker_kyc_pass_flg
        or o.co_sign_unpacker_anti_mon_lau_vrfction_pass_flg <> n.co_sign_unpacker_anti_mon_lau_vrfction_pass_flg
        or o.co_sign_unpacker_netw_vrfction_pass_flg <> n.co_sign_unpacker_netw_vrfction_pass_flg
        or o.agent_4_elmnt <> n.agent_4_elmnt
        or o.agent_open_acct_vrfction_pass_flg <> n.agent_open_acct_vrfction_pass_flg
        or o.agent_kyc_pass_flg <> n.agent_kyc_pass_flg
        or o.agent_anti_mon_lau_vrfction_pass_flg <> n.agent_anti_mon_lau_vrfction_pass_flg
        or o.agent_netw_vrfction_pass_flg <> n.agent_netw_vrfction_pass_flg
        or o.ova_flow_num <> n.ova_flow_num
        or o.bus_flow_num <> n.bus_flow_num
        or o.chn_id <> n.chn_id
        or o.org_id <> n.org_id
        or o.onacct_and_wrtoff_flow_num <> n.onacct_and_wrtoff_flow_num
        or o.trdpty_tran_code <> n.trdpty_tran_code
        or o.core_flow_num <> n.core_flow_num
        or o.core_dt <> n.core_dt
        or o.entry_sub_flow_num <> n.entry_sub_flow_num
        or o.revs_flg <> n.revs_flg
        or o.revs_ova_flow_num <> n.revs_ova_flow_num
        or o.revs_cnt <> n.revs_cnt
        or o.revs_fail_remark <> n.revs_fail_remark
        or o.reply_cd <> n.reply_cd
        or o.reply_info <> n.reply_info
        or o.final_update_dt <> n.final_update_dt
        or o.rent_safebox_status_cd <> n.rent_safebox_status_cd
        or o.rent_safebox_dt <> n.rent_safebox_dt
        or o.rent_safebox_exp_dt <> n.rent_safebox_exp_dt
        or o.proc_teller_id <> n.proc_teller_id
        or o.auth_teller_id <> n.auth_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,safe_box_id -- 保管箱编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,pay_acct_id -- 付款账户编号
    ,pay_sub_acct_num -- 付款子账号
    ,payer_name -- 付款人名称
    ,payer_prod_id -- 付款方产品编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_sub_acct_num -- 收款子账号
    ,recvbl_acct_name -- 收款账户名称
    ,recver_prod_id -- 收款方产品编号
    ,margin -- 押金
    ,curr_cd -- 币种代码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_id -- 凭证编号
    ,vouch_invalid_dt -- 凭证失效日期
    ,cap_src_cd -- 资金来源代码
    ,unpacker_9elmnt -- 开箱人9要素
    ,unpacker_20elmnt -- 开箱人20要素
    ,unpacker_open_acct_vrfction_pass_flg -- 开箱人开户核查通过标志
    ,unpacker_kyc_pass_flg -- 开箱人KYC核查通过标志
    ,unpacker_anti_mon_lau_vrfction_pass_flg -- 开箱人反洗钱核查通过标志
    ,unpacker_netw_vrfction_pass_flg -- 开箱人联网核查通过标志
    ,co_sign_unpacker_9elmnt -- 联名开箱人9要素
    ,co_sign_unpacker_open_acct_vrfction_pass_flg -- 联名开箱人开户核查通过标志
    ,co_sign_unpacker_kyc_pass_flg -- 联名开箱人KYC核查通过标志
    ,co_sign_unpacker_anti_mon_lau_vrfction_pass_flg -- 联名开箱人反洗钱核查通过标志
    ,co_sign_unpacker_netw_vrfction_pass_flg -- 联名开箱人联网核查通过标志
    ,agent_4_elmnt -- 代理人4要素
    ,agent_open_acct_vrfction_pass_flg -- 代理人开户核查通过标志
    ,agent_kyc_pass_flg -- 代理人KYC核查通过标志
    ,agent_anti_mon_lau_vrfction_pass_flg -- 代理人反洗钱核查通过标志
    ,agent_netw_vrfction_pass_flg -- 代理人联网核查通过标志
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,chn_id -- 渠道编号
    ,org_id -- 机构编号
    ,onacct_and_wrtoff_flow_num -- 挂销流水号
    ,trdpty_tran_code -- 第三方交易码
    ,core_flow_num -- 核心流水号
    ,core_dt -- 核心日期
    ,entry_sub_flow_num -- 记账子流水号
    ,revs_flg -- 冲正标志
    ,revs_ova_flow_num -- 冲正全局流水号
    ,revs_cnt -- 冲正次数
    ,revs_fail_remark -- 冲正失败备注
    ,reply_cd -- 应答码
    ,reply_info -- 应答信息
    ,final_update_dt -- 最后更新日期
    ,rent_safebox_status_cd -- 租箱状态代码
    ,rent_safebox_dt -- 租箱日期
    ,rent_safebox_exp_dt -- 租箱到期日期
    ,proc_teller_id -- 处理柜员编号
    ,auth_teller_id -- 授权柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,safe_box_id -- 保管箱编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,pay_acct_id -- 付款账户编号
    ,pay_sub_acct_num -- 付款子账号
    ,payer_name -- 付款人名称
    ,payer_prod_id -- 付款方产品编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_sub_acct_num -- 收款子账号
    ,recvbl_acct_name -- 收款账户名称
    ,recver_prod_id -- 收款方产品编号
    ,margin -- 押金
    ,curr_cd -- 币种代码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_id -- 凭证编号
    ,vouch_invalid_dt -- 凭证失效日期
    ,cap_src_cd -- 资金来源代码
    ,unpacker_9elmnt -- 开箱人9要素
    ,unpacker_20elmnt -- 开箱人20要素
    ,unpacker_open_acct_vrfction_pass_flg -- 开箱人开户核查通过标志
    ,unpacker_kyc_pass_flg -- 开箱人KYC核查通过标志
    ,unpacker_anti_mon_lau_vrfction_pass_flg -- 开箱人反洗钱核查通过标志
    ,unpacker_netw_vrfction_pass_flg -- 开箱人联网核查通过标志
    ,co_sign_unpacker_9elmnt -- 联名开箱人9要素
    ,co_sign_unpacker_open_acct_vrfction_pass_flg -- 联名开箱人开户核查通过标志
    ,co_sign_unpacker_kyc_pass_flg -- 联名开箱人KYC核查通过标志
    ,co_sign_unpacker_anti_mon_lau_vrfction_pass_flg -- 联名开箱人反洗钱核查通过标志
    ,co_sign_unpacker_netw_vrfction_pass_flg -- 联名开箱人联网核查通过标志
    ,agent_4_elmnt -- 代理人4要素
    ,agent_open_acct_vrfction_pass_flg -- 代理人开户核查通过标志
    ,agent_kyc_pass_flg -- 代理人KYC核查通过标志
    ,agent_anti_mon_lau_vrfction_pass_flg -- 代理人反洗钱核查通过标志
    ,agent_netw_vrfction_pass_flg -- 代理人联网核查通过标志
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,chn_id -- 渠道编号
    ,org_id -- 机构编号
    ,onacct_and_wrtoff_flow_num -- 挂销流水号
    ,trdpty_tran_code -- 第三方交易码
    ,core_flow_num -- 核心流水号
    ,core_dt -- 核心日期
    ,entry_sub_flow_num -- 记账子流水号
    ,revs_flg -- 冲正标志
    ,revs_ova_flow_num -- 冲正全局流水号
    ,revs_cnt -- 冲正次数
    ,revs_fail_remark -- 冲正失败备注
    ,reply_cd -- 应答码
    ,reply_info -- 应答信息
    ,final_update_dt -- 最后更新日期
    ,rent_safebox_status_cd -- 租箱状态代码
    ,rent_safebox_dt -- 租箱日期
    ,rent_safebox_exp_dt -- 租箱到期日期
    ,proc_teller_id -- 处理柜员编号
    ,auth_teller_id -- 授权柜员编号
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
    ,o.midgrod_flow_num -- 中台流水号
    ,o.tran_dt -- 交易日期
    ,o.tran_code -- 交易码
    ,o.tran_status_cd -- 交易状态代码
    ,o.safe_box_id -- 保管箱编号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.cust_type_cd -- 客户类型代码
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.pay_acct_id -- 付款账户编号
    ,o.pay_sub_acct_num -- 付款子账号
    ,o.payer_name -- 付款人名称
    ,o.payer_prod_id -- 付款方产品编号
    ,o.recvbl_acct_id -- 收款账户编号
    ,o.recvbl_sub_acct_num -- 收款子账号
    ,o.recvbl_acct_name -- 收款账户名称
    ,o.recver_prod_id -- 收款方产品编号
    ,o.margin -- 押金
    ,o.curr_cd -- 币种代码
    ,o.vouch_type_cd -- 凭证类型代码
    ,o.vouch_id -- 凭证编号
    ,o.vouch_invalid_dt -- 凭证失效日期
    ,o.cap_src_cd -- 资金来源代码
    ,o.unpacker_9elmnt -- 开箱人9要素
    ,o.unpacker_20elmnt -- 开箱人20要素
    ,o.unpacker_open_acct_vrfction_pass_flg -- 开箱人开户核查通过标志
    ,o.unpacker_kyc_pass_flg -- 开箱人KYC核查通过标志
    ,o.unpacker_anti_mon_lau_vrfction_pass_flg -- 开箱人反洗钱核查通过标志
    ,o.unpacker_netw_vrfction_pass_flg -- 开箱人联网核查通过标志
    ,o.co_sign_unpacker_9elmnt -- 联名开箱人9要素
    ,o.co_sign_unpacker_open_acct_vrfction_pass_flg -- 联名开箱人开户核查通过标志
    ,o.co_sign_unpacker_kyc_pass_flg -- 联名开箱人KYC核查通过标志
    ,o.co_sign_unpacker_anti_mon_lau_vrfction_pass_flg -- 联名开箱人反洗钱核查通过标志
    ,o.co_sign_unpacker_netw_vrfction_pass_flg -- 联名开箱人联网核查通过标志
    ,o.agent_4_elmnt -- 代理人4要素
    ,o.agent_open_acct_vrfction_pass_flg -- 代理人开户核查通过标志
    ,o.agent_kyc_pass_flg -- 代理人KYC核查通过标志
    ,o.agent_anti_mon_lau_vrfction_pass_flg -- 代理人反洗钱核查通过标志
    ,o.agent_netw_vrfction_pass_flg -- 代理人联网核查通过标志
    ,o.ova_flow_num -- 全局流水号
    ,o.bus_flow_num -- 业务流水号
    ,o.chn_id -- 渠道编号
    ,o.org_id -- 机构编号
    ,o.onacct_and_wrtoff_flow_num -- 挂销流水号
    ,o.trdpty_tran_code -- 第三方交易码
    ,o.core_flow_num -- 核心流水号
    ,o.core_dt -- 核心日期
    ,o.entry_sub_flow_num -- 记账子流水号
    ,o.revs_flg -- 冲正标志
    ,o.revs_ova_flow_num -- 冲正全局流水号
    ,o.revs_cnt -- 冲正次数
    ,o.revs_fail_remark -- 冲正失败备注
    ,o.reply_cd -- 应答码
    ,o.reply_info -- 应答信息
    ,o.final_update_dt -- 最后更新日期
    ,o.rent_safebox_status_cd -- 租箱状态代码
    ,o.rent_safebox_dt -- 租箱日期
    ,o.rent_safebox_exp_dt -- 租箱到期日期
    ,o.proc_teller_id -- 处理柜员编号
    ,o.auth_teller_id -- 授权柜员编号
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
from ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_bk o
    left join ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_tsafebox_bus_flow;
--alter table ${iml_schema}.evt_tsafebox_bus_flow truncate partition for ('mpcsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_tsafebox_bus_flow') 
               and substr(subpartition_name,1,8)=upper('p_mpcsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_tsafebox_bus_flow drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_tsafebox_bus_flow modify partition p_mpcsf1 
add subpartition p_mpcsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_tsafebox_bus_flow exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_cl;
alter table ${iml_schema}.evt_tsafebox_bus_flow exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_tsafebox_bus_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_tm purge;
drop table ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_op purge;
drop table ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_tsafebox_bus_flow_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_tsafebox_bus_flow', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
