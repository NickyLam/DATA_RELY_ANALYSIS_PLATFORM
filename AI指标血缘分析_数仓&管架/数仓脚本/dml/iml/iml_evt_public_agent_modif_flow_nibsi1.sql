/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_public_agent_modif_flow_nibsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_public_agent_modif_flow_nibsi1_tm purge;
alter table ${iml_schema}.evt_public_agent_modif_flow add partition p_nibsi1 values ('nibsi1')(
        subpartition p_nibsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_public_agent_modif_flow modify partition p_nibsi1
    add subpartition p_nibsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_public_agent_modif_flow_nibsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,modif_flow_num -- 修改流水号
    ,modif_dt -- 修改日期
    ,unify_info_que_flow_num -- 统一信息查询流水号
    ,init_tran_dt -- 原交易日期
    ,init_tran_bus_flow_num -- 原交易业务流水号
    ,init_tran_ova_flow_num -- 原交易全局流水号
    ,blip_batch_no -- 影像批次号
    ,agent_flg -- 代办标志
    ,public_agent_type_cd -- 代办人类型代码
    ,public_agent_name -- 代办人名称
    ,agent_reason_descb -- 代办理由描述
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cont_num -- 联系号码
    ,nation_cd -- 国籍代码
    ,gender_cd -- 性别代码
    ,career_cd_one -- 职业代码一
    ,career_descb_one -- 职业描述一
    ,career_cd_two -- 职业代码二
    ,career_descb_two -- 职业描述二
    ,career_dtl_comnt -- 职业详细说明
    ,cont_addr_prov_cd -- 联系地址-省级代码
    ,cont_addr_prov_name -- 联系地址-省级名称
    ,cont_addr_city_cd -- 联系地址-市级代码
    ,cont_addr_city_name -- 联系地址-市级名称
    ,cont_addr_rg_cd -- 联系地址-区级代码
    ,cont_addr_rg_name -- 联系地址-区级名称
    ,cont_addr -- 联系地址
    ,licen_issue_autho_addr -- 发证机关地址
    ,cert_start_dt -- 证件开始日期
    ,cert_exp_dt -- 证件到期日期
    ,netw_vrfction_flow_num -- 联网核查流水号
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,netw_vrfction_rule_rest_cd -- 联网核查手工审定结果代码
    ,face_recn_rest_cd -- 人脸识别结果代码
    ,face_recn_score -- 人脸识别分数
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_public_agent_modif_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- nibs_ib_log_agentfill_info-1
insert into ${iml_schema}.evt_public_agent_modif_flow_nibsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,modif_flow_num -- 修改流水号
    ,modif_dt -- 修改日期
    ,unify_info_que_flow_num -- 统一信息查询流水号
    ,init_tran_dt -- 原交易日期
    ,init_tran_bus_flow_num -- 原交易业务流水号
    ,init_tran_ova_flow_num -- 原交易全局流水号
    ,blip_batch_no -- 影像批次号
    ,agent_flg -- 代办标志
    ,public_agent_type_cd -- 代办人类型代码
    ,public_agent_name -- 代办人名称
    ,agent_reason_descb -- 代办理由描述
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cont_num -- 联系号码
    ,nation_cd -- 国籍代码
    ,gender_cd -- 性别代码
    ,career_cd_one -- 职业代码一
    ,career_descb_one -- 职业描述一
    ,career_cd_two -- 职业代码二
    ,career_descb_two -- 职业描述二
    ,career_dtl_comnt -- 职业详细说明
    ,cont_addr_prov_cd -- 联系地址-省级代码
    ,cont_addr_prov_name -- 联系地址-省级名称
    ,cont_addr_city_cd -- 联系地址-市级代码
    ,cont_addr_city_name -- 联系地址-市级名称
    ,cont_addr_rg_cd -- 联系地址-区级代码
    ,cont_addr_rg_name -- 联系地址-区级名称
    ,cont_addr -- 联系地址
    ,licen_issue_autho_addr -- 发证机关地址
    ,cert_start_dt -- 证件开始日期
    ,cert_exp_dt -- 证件到期日期
    ,netw_vrfction_flow_num -- 联网核查流水号
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,netw_vrfction_rule_rest_cd -- 联网核查手工审定结果代码
    ,face_recn_rest_cd -- 人脸识别结果代码
    ,face_recn_score -- 人脸识别分数
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401044'||P1.CHAN_BIZ_SEQ_NUM||P1.CHANNELDATE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CHAN_BIZ_SEQ_NUM -- 修改流水号
    ,P1.CHANNELTIME -- 修改日期
    ,P1.TX_SEQ_NUM -- 统一信息查询流水号
    ,P1.ORIG_CHANNELDATE -- 原交易日期
    ,P1.ORIG_TX_SEQ_NUM -- 原交易业务流水号
    ,P1.ORIG_CORE_TRAN_FLOW_NUM -- 原交易全局流水号
    ,P1.BLIP_ID -- 影像批次号
    ,decode(trim(P1.ISAGENT),'Y','1','N','0','','-',P1.ISAGENT) -- 代办标志
    ,nvl(trim（P1.AGENT_TYPE),'-') -- 代办人类型代码
    ,P1.AGENT_PERSON_NAME -- 代办人名称
    ,P1.AGENT_PERSON_REASON -- 代办理由描述
    ,nvl(trim（P1.AGENT_PERSON_CERT_TYPE_CD),'0000') -- 证件类型代码
    ,P1.AGENT_PERSON_CERT_NUM -- 证件号码
    ,P1.AGENT_PERSON_TEL_NUM -- 联系号码
    ,nvl(trim（P1.AGENT_PERSON_NATION_CD),'XXX') -- 国籍代码
    ,nvl(trim（P1.AGENT_GENDER_CD),'0') -- 性别代码
    ,nvl(trim（P1.AGENT_CAREER_TYPEONE_CODE),'-') -- 职业代码一
    ,P1.AGENT_CAREER_TYPEONE -- 职业描述一
    ,nvl(trim（P1.AGENT_CAREER_TYPETWO_CODE),'-') -- 职业代码二
    ,P1.AGENT_CAREER_TYPETWO -- 职业描述二
    ,P1.AGENT_CAREER_CD -- 职业详细说明
    ,nvl(trim（P1.AGENT_PERSON_PROVINCECODE),'000000') -- 联系地址-省级代码
    ,P1.AGENT_PERSON_PROVINCE -- 联系地址-省级名称
    ,nvl(trim（P1.AGENT_PERSON_CITYCODE),'000000') -- 联系地址-市级代码
    ,P1.AGENT_PERSON_CITY -- 联系地址-市级名称
    ,nvl(trim（P1.AGENT_PERSON_COUNTYCODE),'000000') -- 联系地址-区级代码
    ,P1.AGENT_PERSON_COUNTY -- 联系地址-区级名称
    ,P1.AGENT_PERSON_CONTACT_ADR -- 联系地址
    ,P1.AGENT_PERSON_AUTH_ADR -- 发证机关地址
    ,${iml_schema}.dateformat_min(P1.AGENT_PERSON_START_DT) -- 证件开始日期
    ,${iml_schema}.dateformat_max2(P1.AGENT_PERSON_END_DT) -- 证件到期日期
    ,P1.AGENT_PERSON_NETWORKCHK_SERNO -- 联网核查流水号
    ,nvl(trim（P1.AGENT_PERSON_NETWORKCHK_RET),'-') -- 联网核查结果代码
    ,nvl(trim（P1.AGENT_PERSON_HANDCHK_RET),'-') -- 联网核查手工审定结果代码
    ,nvl(trim（P1.AGENT_PERSON_FACEIDENT_RES),'-') -- 人脸识别结果代码
    ,P1.AGENT_PERSON_FACEIDENT_SCORE -- 人脸识别分数
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nibs_ib_log_agentfill_info' -- 源表名称
    ,'nibsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nibs_ib_log_agentfill_info p1
where  1 = 1 
    and P1.ETL_DT = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_public_agent_modif_flow truncate subpartition p_nibsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_public_agent_modif_flow exchange subpartition p_nibsi1_${batch_date} with table ${iml_schema}.evt_public_agent_modif_flow_nibsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_public_agent_modif_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_public_agent_modif_flow_nibsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_public_agent_modif_flow', partname => 'p_nibsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);