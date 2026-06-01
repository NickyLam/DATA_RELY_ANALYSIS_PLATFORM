/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1wsp_batch_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1wsp_batch_info
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1wsp_batch_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1wsp_batch_info(
    batch_no varchar2(192) -- 批次编号
    ,batch_step varchar2(12) -- 批次步骤(00-初始化;01-申请;02-代发;03-企业网银)
    ,batch_status varchar2(12) -- 批次状态(00-初始化;01-处理成功;02-处理失败;03-已撤回;99-处理中)
    ,refund_status varchar2(12) -- 退款状态(00-无需退款;01-待退款;02-退款成功;03-退款失败;04-退款状态未知;99-退款中)
    ,pay_acct_no varchar2(192) -- 代发账户
    ,pay_source varchar2(12) -- 代发来源(1-上传文件;2-薪酬计算)
    ,pay_type varchar2(6) -- 代发类型(1-工资;2-报销;3-奖金;4-其他)
    ,batch_date varchar2(144) -- 批次日期
    ,batch_time varchar2(144) -- 批次时间
    ,batch_finish_time varchar2(144) -- 批次完成时间
    ,total_dtl_num varchar2(48) -- 总笔数
    ,total_amt varchar2(156) -- 总金额
    ,average_amt varchar2(156) -- 平均金额
    ,success_amt varchar2(156) -- 代发成功金额
    ,fail_amt varchar2(156) -- 代发失败总金额
    ,succ_dtl_num varchar2(48) -- 代发成功数
    ,fail_dtl_num varchar2(48) -- 代发失败数
    ,unknown_dtl_num varchar2(48) -- 代发交易状态未知数
    ,fee_amt varchar2(156) -- 手续费金额
    ,matter_id varchar2(192) -- 审批事项ID
    ,batch_month varchar2(12) -- 所属月份
    ,batch_year varchar2(24) -- 所属年份
    ,batch_title varchar2(1536) -- 批次标题
    ,total_people_count varchar2(48) -- 总人数
    ,summary_name varchar2(384) -- 摘要名称
    ,salary_info varchar2(1536) -- 薪金说明
    ,company_id varchar2(192) -- 企业ID
    ,company_name varchar2(768) -- 企业名称
    ,salary_group_id varchar2(192) -- 薪酬组ID
    ,branch_no varchar2(192) -- 机构编号
    ,show_dtl_flag varchar2(12) -- 是否展示代发明细(Y-是;N-否)
    ,lock_flag varchar2(36) -- 锁定标志(UNLOCK-未锁定;LOCK-锁定)
    ,batch_file_name varchar2(1536) -- 代发批次文件名称
    ,batch_file_md5 varchar2(1536) -- 代发批次文件MD5
    ,create_timestamp varchar2(144) -- 创建时间戳
    ,update_timestamp varchar2(144) -- 更新时间戳
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a1wsp_batch_info to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1wsp_batch_info to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1wsp_batch_info to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1wsp_batch_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1wsp_batch_info is '代发批次信息表';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.batch_no is '批次编号';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.batch_step is '批次步骤(00-初始化;01-申请;02-代发;03-企业网银)';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.batch_status is '批次状态(00-初始化;01-处理成功;02-处理失败;03-已撤回;99-处理中)';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.refund_status is '退款状态(00-无需退款;01-待退款;02-退款成功;03-退款失败;04-退款状态未知;99-退款中)';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.pay_acct_no is '代发账户';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.pay_source is '代发来源(1-上传文件;2-薪酬计算)';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.pay_type is '代发类型(1-工资;2-报销;3-奖金;4-其他)';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.batch_date is '批次日期';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.batch_time is '批次时间';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.batch_finish_time is '批次完成时间';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.total_dtl_num is '总笔数';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.total_amt is '总金额';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.average_amt is '平均金额';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.success_amt is '代发成功金额';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.fail_amt is '代发失败总金额';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.succ_dtl_num is '代发成功数';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.fail_dtl_num is '代发失败数';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.unknown_dtl_num is '代发交易状态未知数';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.fee_amt is '手续费金额';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.matter_id is '审批事项ID';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.batch_month is '所属月份';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.batch_year is '所属年份';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.batch_title is '批次标题';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.total_people_count is '总人数';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.summary_name is '摘要名称';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.salary_info is '薪金说明';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.company_id is '企业ID';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.company_name is '企业名称';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.salary_group_id is '薪酬组ID';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.branch_no is '机构编号';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.show_dtl_flag is '是否展示代发明细(Y-是;N-否)';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.lock_flag is '锁定标志(UNLOCK-未锁定;LOCK-锁定)';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.batch_file_name is '代发批次文件名称';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.batch_file_md5 is '代发批次文件MD5';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1wsp_batch_info.etl_timestamp is 'ETL处理时间戳';
