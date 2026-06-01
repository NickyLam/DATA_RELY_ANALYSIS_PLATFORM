/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl fdms_t99_std_code
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.fdms_t99_std_code
whenever sqlerror continue none;
drop table ${idl_schema}.fdms_t99_std_code purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.fdms_t99_std_code(
			 BDP_SRC_TB_TRUNK_NAME  VARCHAR2(200)
			,BDP_SRC_FIELD_NAME     VARCHAR2(200)
			,SRC_CD_VAL             VARCHAR2(200)
			,SRC_CD_DESC            VARCHAR2(200)
			,TARGET_CN_NAME         VARCHAR2(200)
			,TARGET_EN_NAME         VARCHAR2(200)
			,TARGET_CD_VAL          VARCHAR2(200)
			,TARGET_CD_DESC         VARCHAR2(200)
			,MEMO                   VARCHAR2(200)
			,ETL_DT	DATE
      ,job_cd varchar2(10) -- 任务代码
      ,etl_timestamp timestamp -- 数据处理时间
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.fdms_t99_std_code to ${iel_schema};
