/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_log_agentfill_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_log_agentfill_info_ex purge;
alter table ${iol_schema}.nibs_ib_log_agentfill_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.nibs_ib_log_agentfill_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.nibs_ib_log_agentfill_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_log_agentfill_info where 0=1;

insert /*+ append */ into ${iol_schema}.nibs_ib_log_agentfill_info_ex(
    channeldate -- 渠道日期
    ,chan_biz_seq_num -- 渠道流水号
    ,tx_seq_num -- 业务流水号
    ,orig_tx_seq_num -- 原交易业务流水号（交易订单号）
    ,orig_core_tran_flow_num -- 原交易全局流水号
    ,blip_id -- 影像批次号
    ,isagent -- 是否代办
    ,agent_person_name -- 代办人名称
    ,agent_person_cert_type_cd -- 代办人证件类型
    ,agent_person_cert_num -- 代办人证件号码
    ,agent_person_tel_num -- 代办人手机号或代办人电话号码
    ,agent_person_nation_cd -- 代办人国籍
    ,agent_gender_cd -- 代办人性别
    ,agent_career_typeone_code -- 代办人职业-分类1代码
    ,agent_career_typeone -- 代办人职业-分类1名称
    ,agent_career_typetwo_code -- 代办人职业-分类2代码
    ,agent_career_typetwo -- 代办人职业-分类2名称
    ,agent_career_cd -- 代办人职业（详细说明）
    ,agent_person_provincecode -- 代办人联系地址-省代码
    ,agent_person_province -- 代办人联系地址-省名称
    ,agent_person_citycode -- 代办人联系地址-市代码
    ,agent_person_city -- 代办人联系地址-市名称
    ,agent_person_countycode -- 代办人联系地址-区代码
    ,agent_person_county -- 代办人联系地址-区名称
    ,agent_person_contact_adr -- 代办人联系地址（详细地址）
    ,agent_person_auth_adr -- 代办人发证机关地址
    ,agent_person_start_dt -- 代办人证件开始日期
    ,agent_person_end_dt -- 代办人证件到期日期
    ,agent_type -- 代理人类型（1-普通代理；2-监护代理；3-经办人办理）
    ,agent_person_reason -- 代办理由
    ,agent_person_networkchk_serno -- 代办人联网核查流水号
    ,agent_person_networkchk_ret -- 代办人联网核查结果
    ,agent_person_faceident_res -- 代办人人脸识别结果
    ,agent_person_faceident_score -- 代办人人脸识别分数
    ,agent_person_handchk_ret -- 代办人手工审定结果 1-通过 2-强制通过 3-不通过
    ,note1 -- 备用1
    ,note2 -- 备用2
    ,orig_channeldate -- 原交易渠道日期
    ,org_num -- 机构编号
    ,teller_num -- 柜员编号
    ,channeltime -- 渠道时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    channeldate -- 渠道日期
    ,chan_biz_seq_num -- 渠道流水号
    ,tx_seq_num -- 业务流水号
    ,orig_tx_seq_num -- 原交易业务流水号（交易订单号）
    ,orig_core_tran_flow_num -- 原交易全局流水号
    ,blip_id -- 影像批次号
    ,isagent -- 是否代办
    ,agent_person_name -- 代办人名称
    ,agent_person_cert_type_cd -- 代办人证件类型
    ,agent_person_cert_num -- 代办人证件号码
    ,agent_person_tel_num -- 代办人手机号或代办人电话号码
    ,agent_person_nation_cd -- 代办人国籍
    ,agent_gender_cd -- 代办人性别
    ,agent_career_typeone_code -- 代办人职业-分类1代码
    ,agent_career_typeone -- 代办人职业-分类1名称
    ,agent_career_typetwo_code -- 代办人职业-分类2代码
    ,agent_career_typetwo -- 代办人职业-分类2名称
    ,agent_career_cd -- 代办人职业（详细说明）
    ,agent_person_provincecode -- 代办人联系地址-省代码
    ,agent_person_province -- 代办人联系地址-省名称
    ,agent_person_citycode -- 代办人联系地址-市代码
    ,agent_person_city -- 代办人联系地址-市名称
    ,agent_person_countycode -- 代办人联系地址-区代码
    ,agent_person_county -- 代办人联系地址-区名称
    ,agent_person_contact_adr -- 代办人联系地址（详细地址）
    ,agent_person_auth_adr -- 代办人发证机关地址
    ,agent_person_start_dt -- 代办人证件开始日期
    ,agent_person_end_dt -- 代办人证件到期日期
    ,agent_type -- 代理人类型（1-普通代理；2-监护代理；3-经办人办理）
    ,agent_person_reason -- 代办理由
    ,agent_person_networkchk_serno -- 代办人联网核查流水号
    ,agent_person_networkchk_ret -- 代办人联网核查结果
    ,agent_person_faceident_res -- 代办人人脸识别结果
    ,agent_person_faceident_score -- 代办人人脸识别分数
    ,agent_person_handchk_ret -- 代办人手工审定结果 1-通过 2-强制通过 3-不通过
    ,note1 -- 备用1
    ,note2 -- 备用2
    ,orig_channeldate -- 原交易渠道日期
    ,org_num -- 机构编号
    ,teller_num -- 柜员编号
    ,channeltime -- 渠道时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nibs_ib_log_agentfill_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nibs_ib_log_agentfill_info exchange partition p_${batch_date} with table ${iol_schema}.nibs_ib_log_agentfill_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_log_agentfill_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nibs_ib_log_agentfill_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_log_agentfill_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);