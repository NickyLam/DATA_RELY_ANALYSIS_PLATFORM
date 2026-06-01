/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_pbss_flw_t_main_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pbss_flw_t_main_flow
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pbss_flw_t_main_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pbss_flw_t_main_flow(
    ETL_DT DATE
    ,ID VARCHAR2(32)
    ,PROCESS_INST_ID VARCHAR2(50)
    ,ARC_ID VARCHAR2(32)
    ,SCAN_SEQ_NO VARCHAR2(30)
    ,TR_CODE VARCHAR2(9)
    ,TR_DATE DATE
    ,BIZ_CODE VARCHAR2(6)
    ,BACK_OPER_CENTER_ID VARCHAR2(32)
    ,BR_TRACE_NO VARCHAR2(32)
    ,BIZ_PRIORITY NUMBER
    ,MAIN_NOTE_PAGES NUMBER
    ,ATTACH_PAGES NUMBER
    ,MAG_PRINT_FLAG VARCHAR2(1)
    ,ACCPT_TIME TIMESTAMP(6)
    ,END_TIME TIMESTAMP(6)
    ,SCAN_OPR_NO VARCHAR2(12)
    ,FR_TLR_OPR_NO VARCHAR2(12)
    ,FR_CHRG_OPR_NO VARCHAR2(12)
    ,AUTH_FLAG VARCHAR2(1)
    ,TX_STATUS VARCHAR2(2)
    ,RET_REASON VARCHAR2(500)
    ,PRE_FLAG VARCHAR2(1)
    ,RESERVE1 VARCHAR2(100)
    ,RESERVE2 VARCHAR2(100)
    ,BIZ_PRE_TIME NUMBER
    ,AUTH_REASON VARCHAR2(100)
    ,TACHE_CODE VARCHAR2(16)
    ,PROCESSOR VARCHAR2(12)
    ,RECEIVE_NO VARCHAR2(32)
    ,BACK_CHECK_FLAG VARCHAR2(1)
    ,BACK_AUTH_FLAG VARCHAR2(1)
    ,BACK_CHECK_DATE DATE
    ,OLDSCANNO VARCHAR2(32)
    ,IS_SYS_OP VARCHAR2(1)
    ,MAIN_SCAN_SEQ_NO VARCHAR2(32)
    ,FIRST_ACCPT_TIME DATE
    ,DELTA_PRIORITY NUMBER
    ,BUSI_CHECK_FLAG VARCHAR2(1)
    ,BUSI_CHECK_TIME DATE
    ,BUSI_CHECK_USER VARCHAR2(12)
    ,ROOT_SCAN_SEQ_NO VARCHAR2(30)
    ,MODIFY_TIME DATE
    ,BUSI_START_TIME DATE
    ,BUSI_END_TIME DATE
    ,STATIS_TACHE_FLAG VARCHAR2(1)
    ,SYS_ID VARCHAR2(10)
    ,NETSTATE VARCHAR2(1)
    ,LOGONPWNEW VARCHAR2(300)
    ,NETRESET VARCHAR2(1)
    ,FIRST_CHECK_USER VARCHAR2(20)
    ,SECOND_CHECK_USER VARCHAR2(20)
    ,FR_END_STATUS VARCHAR2(2)
    ,FR_END_REASON VARCHAR2(100)
    ,MTWO_SEAL_REASON VARCHAR2(250)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pbss_flw_t_main_flow to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pbss_flw_t_main_flow is '主流水表';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.ID is '逻辑主键';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.PROCESS_INST_ID is '流程实例id';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.ARC_ID is '卷宗ID';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.SCAN_SEQ_NO is '扫描流水号';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.TR_CODE is '交易机构';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.TR_DATE is '交易日期';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.BIZ_CODE is '业务编码[代码T007][参考CFG_T_BIZ_CODE]';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.BACK_OPER_CENTER_ID is '后台作业中心ID';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.BR_TRACE_NO is '网点流水号';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.BIZ_PRIORITY is '业务优先级[代码0030][100-普通200-加急300-绿色通道（特急）]';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.MAIN_NOTE_PAGES is '主件张数';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.ATTACH_PAGES is '附件张数';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.MAG_PRINT_FLAG is '磁码打印标志[代码0034][0-否1-是]';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.ACCPT_TIME is '平台受理时间';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.END_TIME is '业务结束时间';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.SCAN_OPR_NO is '扫描柜员号';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.FR_TLR_OPR_NO is '前台柜员号';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.FR_CHRG_OPR_NO is '前台主管';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.AUTH_FLAG is '授权标志[代码0019][0-未授权1-已授权2-补授权]';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.TX_STATUS is '处理状态[代码0084][1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.RET_REASON is '退票理由';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.PRE_FLAG is '预处理标志[代码0034][0-否1-是]';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.RESERVE1 is '备用字段1';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.RESERVE2 is '备用字段2';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.BIZ_PRE_TIME is '业务预计时长';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.AUTH_REASON is '授权原因';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.TACHE_CODE is '结束环节';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.PROCESSOR is '处理人';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.RECEIVE_NO is '受理号';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.BACK_CHECK_FLAG is '后台复核标记(1-复核通过)';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.BACK_AUTH_FLAG is '后台授权标记(1-授权通过)';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.BACK_CHECK_DATE is '后台复核通过时间';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.OLDSCANNO is '重发时旧的扫描流水号';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.IS_SYS_OP is '是否同步OP(0未同步1已同步)';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.MAIN_SCAN_SEQ_NO is '主流水扫描流水号';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.FIRST_ACCPT_TIME is '首次受理时间';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.DELTA_PRIORITY is '调整优先级，流程发起时传给引擎';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.BUSI_CHECK_FLAG is '业务勾兑标识 0-未勾兑 1-已勾兑';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.BUSI_CHECK_TIME is '业务勾兑时间';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.BUSI_CHECK_USER is '业务勾兑操作用户';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.ROOT_SCAN_SEQ_NO is '根扫描流水号(注意：暂只有对公开户业务预受理业务使用)';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.MODIFY_TIME is '修改时间(注意：暂只有对公开户业务预受理业务使用)';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.BUSI_START_TIME is '业务开始时间（用于计算特殊业务办法时间）';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.BUSI_END_TIME is '业务结束时间（用于计算特殊业务办法时间）';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.STATIS_TACHE_FLAG is '统计流程环节耗时标识 0-未统计 1-统计';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.SYS_ID is '渠道码 003-受理中心 EBK-网银  PAD-移动终端';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.NETSTATE is '';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.LOGONPWNEW is '';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.NETRESET is '';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.FIRST_CHECK_USER is '';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.SECOND_CHECK_USER is '';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.FR_END_STATUS is '前台结束标志（-1结束）';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.FR_END_REASON is '前台结束标志';
comment on column ${msl_schema}.msl_edw_pbss_flw_t_main_flow.MTWO_SEAL_REASON is '验印不通过原因';
