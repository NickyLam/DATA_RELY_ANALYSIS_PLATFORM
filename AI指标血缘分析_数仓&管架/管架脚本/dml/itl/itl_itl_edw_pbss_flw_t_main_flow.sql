/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pbss_flw_t_main_flow
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_pbss_flw_t_main_flow drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pbss_flw_t_main_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pbss_flw_t_main_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pbss_flw_t_main_flow partition for (to_date('${batch_date}','yyyymmdd')) (
    id -- 逻辑主键
    ,process_inst_id -- 流程实例id
    ,arc_id -- 卷宗ID
    ,scan_seq_no -- 扫描流水号
    ,tr_code -- 交易机构
    ,tr_date -- 交易日期
    ,biz_code -- 业务编码[代码T007][参考CFG_T_BIZ_CODE]
    ,back_oper_center_id -- 后台作业中心ID
    ,br_trace_no -- 网点流水号
    ,biz_priority -- 业务优先级[代码0030][100-普通200-加急300-绿色通道（特急）]
    ,main_note_pages -- 主件张数
    ,attach_pages -- 附件张数
    ,mag_print_flag -- 磁码打印标志[代码0034][0-否1-是]
    ,accpt_time -- 平台受理时间
    ,end_time -- 业务结束时间
    ,scan_opr_no -- 扫描柜员号
    ,fr_tlr_opr_no -- 前台柜员号
    ,fr_chrg_opr_no -- 前台主管
    ,auth_flag -- 授权标志[代码0019][0-未授权1-已授权2-补授权]
    ,tx_status -- 处理状态[代码0084][1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
    ,ret_reason -- 退票理由
    ,pre_flag -- 预处理标志[代码0034][0-否1-是]
    ,reserve1 -- 备用字段1
    ,reserve2 -- 备用字段2
    ,biz_pre_time -- 业务预计时长
    ,auth_reason -- 授权原因
    ,tache_code -- 结束环节
    ,processor -- 处理人
    ,receive_no -- 受理号
    ,back_check_flag -- 后台复核标记(1-复核通过)
    ,back_auth_flag -- 后台授权标记(1-授权通过)
    ,back_check_date -- 后台复核通过时间
    ,oldscanno -- 重发时旧的扫描流水号
    ,is_sys_op -- 是否同步OP(0未同步1已同步)
    ,main_scan_seq_no -- 主流水扫描流水号
    ,first_accpt_time -- 首次受理时间
    ,delta_priority -- 调整优先级，流程发起时传给引擎
    ,busi_check_flag -- 业务勾兑标识 0-未勾兑 1-已勾兑
    ,busi_check_time -- 业务勾兑时间
    ,busi_check_user -- 业务勾兑操作用户
    ,root_scan_seq_no -- 根扫描流水号(注意：暂只有对公开户业务预受理业务使用)
    ,modify_time -- 修改时间(注意：暂只有对公开户业务预受理业务使用)
    ,busi_start_time -- 业务开始时间（用于计算特殊业务办法时间）
    ,busi_end_time -- 业务结束时间（用于计算特殊业务办法时间）
    ,statis_tache_flag -- 统计流程环节耗时标识 0-未统计 1-统计
    ,sys_id -- 渠道码 003-受理中心 EBK-网银  PAD-移动终端
    ,netstate -- 
    ,logonpwnew -- 
    ,netreset -- 
    ,first_check_user -- 
    ,second_check_user -- 
    ,fr_end_status -- 前台结束标志（-1结束）
    ,fr_end_reason -- 前台结束标志
    ,mtwo_seal_reason -- 验印不通过原因
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(id), ' ') as id -- 逻辑主键
    ,nvl(trim(process_inst_id), ' ') as process_inst_id -- 流程实例id
    ,nvl(trim(arc_id), ' ') as arc_id -- 卷宗ID
    ,nvl(trim(scan_seq_no), ' ') as scan_seq_no -- 扫描流水号
    ,nvl(trim(tr_code), ' ') as tr_code -- 交易机构
    ,nvl(tr_date, to_date('00010101', 'yyyymmdd')) as tr_date -- 交易日期
    ,nvl(trim(biz_code), ' ') as biz_code -- 业务编码[代码T007][参考CFG_T_BIZ_CODE]
    ,nvl(trim(back_oper_center_id), ' ') as back_oper_center_id -- 后台作业中心ID
    ,nvl(trim(br_trace_no), ' ') as br_trace_no -- 网点流水号
    ,nvl(trim(biz_priority), 0) as biz_priority -- 业务优先级[代码0030][100-普通200-加急300-绿色通道（特急）]
    ,nvl(trim(main_note_pages), 0) as main_note_pages -- 主件张数
    ,nvl(trim(attach_pages), 0) as attach_pages -- 附件张数
    ,nvl(trim(mag_print_flag), ' ') as mag_print_flag -- 磁码打印标志[代码0034][0-否1-是]
    ,nvl(accpt_time, to_timestamp('00010101', 'yyyymmdd')) as accpt_time -- 平台受理时间
    ,nvl(end_time, to_timestamp('00010101', 'yyyymmdd')) as end_time -- 业务结束时间
    ,nvl(trim(scan_opr_no), ' ') as scan_opr_no -- 扫描柜员号
    ,nvl(trim(fr_tlr_opr_no), ' ') as fr_tlr_opr_no -- 前台柜员号
    ,nvl(trim(fr_chrg_opr_no), ' ') as fr_chrg_opr_no -- 前台主管
    ,nvl(trim(auth_flag), ' ') as auth_flag -- 授权标志[代码0019][0-未授权1-已授权2-补授权]
    ,nvl(trim(tx_status), ' ') as tx_status -- 处理状态[代码0084][1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
    ,nvl(trim(ret_reason), ' ') as ret_reason -- 退票理由
    ,nvl(trim(pre_flag), ' ') as pre_flag -- 预处理标志[代码0034][0-否1-是]
    ,nvl(trim(reserve1), ' ') as reserve1 -- 备用字段1
    ,nvl(trim(reserve2), ' ') as reserve2 -- 备用字段2
    ,nvl(trim(biz_pre_time), 0) as biz_pre_time -- 业务预计时长
    ,nvl(trim(auth_reason), ' ') as auth_reason -- 授权原因
    ,nvl(trim(tache_code), ' ') as tache_code -- 结束环节
    ,nvl(trim(processor), ' ') as processor -- 处理人
    ,nvl(trim(receive_no), ' ') as receive_no -- 受理号
    ,nvl(trim(back_check_flag), ' ') as back_check_flag -- 后台复核标记(1-复核通过)
    ,nvl(trim(back_auth_flag), ' ') as back_auth_flag -- 后台授权标记(1-授权通过)
    ,nvl(back_check_date, to_date('00010101', 'yyyymmdd')) as back_check_date -- 后台复核通过时间
    ,nvl(trim(oldscanno), ' ') as oldscanno -- 重发时旧的扫描流水号
    ,nvl(trim(is_sys_op), ' ') as is_sys_op -- 是否同步OP(0未同步1已同步)
    ,nvl(trim(main_scan_seq_no), ' ') as main_scan_seq_no -- 主流水扫描流水号
    ,nvl(first_accpt_time, to_date('00010101', 'yyyymmdd')) as first_accpt_time -- 首次受理时间
    ,nvl(trim(delta_priority), 0) as delta_priority -- 调整优先级，流程发起时传给引擎
    ,nvl(trim(busi_check_flag), ' ') as busi_check_flag -- 业务勾兑标识 0-未勾兑 1-已勾兑
    ,nvl(busi_check_time, to_date('00010101', 'yyyymmdd')) as busi_check_time -- 业务勾兑时间
    ,nvl(trim(busi_check_user), ' ') as busi_check_user -- 业务勾兑操作用户
    ,nvl(trim(root_scan_seq_no), ' ') as root_scan_seq_no -- 根扫描流水号(注意：暂只有对公开户业务预受理业务使用)
    ,nvl(modify_time, to_date('00010101', 'yyyymmdd')) as modify_time -- 修改时间(注意：暂只有对公开户业务预受理业务使用)
    ,nvl(busi_start_time, to_date('00010101', 'yyyymmdd')) as busi_start_time -- 业务开始时间（用于计算特殊业务办法时间）
    ,nvl(busi_end_time, to_date('00010101', 'yyyymmdd')) as busi_end_time -- 业务结束时间（用于计算特殊业务办法时间）
    ,nvl(trim(statis_tache_flag), ' ') as statis_tache_flag -- 统计流程环节耗时标识 0-未统计 1-统计
    ,nvl(trim(sys_id), ' ') as sys_id -- 渠道码 003-受理中心 EBK-网银  PAD-移动终端
    ,nvl(trim(netstate), ' ') as netstate -- 
    ,nvl(trim(logonpwnew), ' ') as logonpwnew -- 
    ,nvl(trim(netreset), ' ') as netreset -- 
    ,nvl(trim(first_check_user), ' ') as first_check_user -- 
    ,nvl(trim(second_check_user), ' ') as second_check_user -- 
    ,nvl(trim(fr_end_status), ' ') as fr_end_status -- 前台结束标志（-1结束）
    ,nvl(trim(fr_end_reason), ' ') as fr_end_reason -- 前台结束标志
    ,nvl(trim(mtwo_seal_reason), ' ') as mtwo_seal_reason -- 验印不通过原因
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pbss_flw_t_main_flow
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pbss_flw_t_main_flow to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pbss_flw_t_main_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);