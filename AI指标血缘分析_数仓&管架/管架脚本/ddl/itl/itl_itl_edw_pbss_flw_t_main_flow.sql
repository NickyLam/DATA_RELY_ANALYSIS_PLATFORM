/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pbss_flw_t_main_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pbss_flw_t_main_flow
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pbss_flw_t_main_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pbss_flw_t_main_flow(
    id varchar2(32) -- 逻辑主键
    ,process_inst_id varchar2(50) -- 流程实例id
    ,arc_id varchar2(32) -- 卷宗ID
    ,scan_seq_no varchar2(30) -- 扫描流水号
    ,tr_code varchar2(9) -- 交易机构
    ,tr_date date -- 交易日期
    ,biz_code varchar2(6) -- 业务编码[代码T007][参考CFG_T_BIZ_CODE]
    ,back_oper_center_id varchar2(32) -- 后台作业中心ID
    ,br_trace_no varchar2(32) -- 网点流水号
    ,biz_priority number -- 业务优先级[代码0030][100-普通200-加急300-绿色通道（特急）]
    ,main_note_pages number -- 主件张数
    ,attach_pages number -- 附件张数
    ,mag_print_flag varchar2(1) -- 磁码打印标志[代码0034][0-否1-是]
    ,accpt_time timestamp -- 平台受理时间
    ,end_time timestamp -- 业务结束时间
    ,scan_opr_no varchar2(12) -- 扫描柜员号
    ,fr_tlr_opr_no varchar2(12) -- 前台柜员号
    ,fr_chrg_opr_no varchar2(12) -- 前台主管
    ,auth_flag varchar2(1) -- 授权标志[代码0019][0-未授权1-已授权2-补授权]
    ,tx_status varchar2(2) -- 处理状态[代码0084][1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
    ,ret_reason varchar2(500) -- 退票理由
    ,pre_flag varchar2(1) -- 预处理标志[代码0034][0-否1-是]
    ,reserve1 varchar2(100) -- 备用字段1
    ,reserve2 varchar2(100) -- 备用字段2
    ,biz_pre_time number -- 业务预计时长
    ,auth_reason varchar2(100) -- 授权原因
    ,tache_code varchar2(16) -- 结束环节
    ,processor varchar2(12) -- 处理人
    ,receive_no varchar2(32) -- 受理号
    ,back_check_flag varchar2(1) -- 后台复核标记(1-复核通过)
    ,back_auth_flag varchar2(1) -- 后台授权标记(1-授权通过)
    ,back_check_date date -- 后台复核通过时间
    ,oldscanno varchar2(32) -- 重发时旧的扫描流水号
    ,is_sys_op varchar2(1) -- 是否同步OP(0未同步1已同步)
    ,main_scan_seq_no varchar2(32) -- 主流水扫描流水号
    ,first_accpt_time date -- 首次受理时间
    ,delta_priority number -- 调整优先级，流程发起时传给引擎
    ,busi_check_flag varchar2(1) -- 业务勾兑标识 0-未勾兑 1-已勾兑
    ,busi_check_time date -- 业务勾兑时间
    ,busi_check_user varchar2(12) -- 业务勾兑操作用户
    ,root_scan_seq_no varchar2(30) -- 根扫描流水号(注意：暂只有对公开户业务预受理业务使用)
    ,modify_time date -- 修改时间(注意：暂只有对公开户业务预受理业务使用)
    ,busi_start_time date -- 业务开始时间（用于计算特殊业务办法时间）
    ,busi_end_time date -- 业务结束时间（用于计算特殊业务办法时间）
    ,statis_tache_flag varchar2(1) -- 统计流程环节耗时标识 0-未统计 1-统计
    ,sys_id varchar2(10) -- 渠道码 003-受理中心 EBK-网银  PAD-移动终端
    ,netstate varchar2(1) -- 
    ,logonpwnew varchar2(300) -- 
    ,netreset varchar2(1) -- 
    ,first_check_user varchar2(20) -- 
    ,second_check_user varchar2(20) -- 
    ,fr_end_status varchar2(2) -- 前台结束标志（-1结束）
    ,fr_end_reason varchar2(100) -- 前台结束标志
    ,mtwo_seal_reason varchar2(250) -- 验印不通过原因
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_pbss_flw_t_main_flow to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pbss_flw_t_main_flow is '主流水表';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.id is '逻辑主键';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.process_inst_id is '流程实例id';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.arc_id is '卷宗ID';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.scan_seq_no is '扫描流水号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.tr_code is '交易机构';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.tr_date is '交易日期';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.biz_code is '业务编码[代码T007][参考CFG_T_BIZ_CODE]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.back_oper_center_id is '后台作业中心ID';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.br_trace_no is '网点流水号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.biz_priority is '业务优先级[代码0030][100-普通200-加急300-绿色通道（特急）]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.main_note_pages is '主件张数';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.attach_pages is '附件张数';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.mag_print_flag is '磁码打印标志[代码0034][0-否1-是]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.accpt_time is '平台受理时间';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.end_time is '业务结束时间';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.scan_opr_no is '扫描柜员号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.fr_tlr_opr_no is '前台柜员号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.fr_chrg_opr_no is '前台主管';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.auth_flag is '授权标志[代码0019][0-未授权1-已授权2-补授权]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.tx_status is '处理状态[代码0084][1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.ret_reason is '退票理由';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.pre_flag is '预处理标志[代码0034][0-否1-是]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.reserve1 is '备用字段1';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.reserve2 is '备用字段2';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.biz_pre_time is '业务预计时长';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.auth_reason is '授权原因';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.tache_code is '结束环节';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.processor is '处理人';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.receive_no is '受理号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.back_check_flag is '后台复核标记(1-复核通过)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.back_auth_flag is '后台授权标记(1-授权通过)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.back_check_date is '后台复核通过时间';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.oldscanno is '重发时旧的扫描流水号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.is_sys_op is '是否同步OP(0未同步1已同步)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.main_scan_seq_no is '主流水扫描流水号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.first_accpt_time is '首次受理时间';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.delta_priority is '调整优先级，流程发起时传给引擎';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.busi_check_flag is '业务勾兑标识 0-未勾兑 1-已勾兑';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.busi_check_time is '业务勾兑时间';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.busi_check_user is '业务勾兑操作用户';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.root_scan_seq_no is '根扫描流水号(注意：暂只有对公开户业务预受理业务使用)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.modify_time is '修改时间(注意：暂只有对公开户业务预受理业务使用)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.busi_start_time is '业务开始时间（用于计算特殊业务办法时间）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.busi_end_time is '业务结束时间（用于计算特殊业务办法时间）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.statis_tache_flag is '统计流程环节耗时标识 0-未统计 1-统计';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.sys_id is '渠道码 003-受理中心 EBK-网银  PAD-移动终端';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.netstate is '';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.logonpwnew is '';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.netreset is '';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.first_check_user is '';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.second_check_user is '';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.fr_end_status is '前台结束标志（-1结束）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.fr_end_reason is '前台结束标志';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.mtwo_seal_reason is '验印不通过原因';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_main_flow.etl_timestamp is 'ETL处理时间戳';