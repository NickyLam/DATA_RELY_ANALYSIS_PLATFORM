/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ppps_tran_batch_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ppps_tran_batch_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ppps_tran_batch_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ppps_tran_batch_info(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,chn_id varchar2(100) -- 渠道编号
    ,chn_tran_flow_num varchar2(100) -- 渠道交易流水号
    ,chn_tran_dt date -- 渠道交易日期
    ,mercht_id varchar2(100) -- 商户编号
    ,chn_sys_cd varchar2(30) -- 渠道系统代码
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,tran_batch_no varchar2(100) -- 交易批次号
    ,tran_dt date -- 交易日期
    ,tran_batch_status_cd varchar2(30) -- 交易批次状态代码
    ,sys_id varchar2(100) -- 系统编号
    ,tran_cate_cd varchar2(30) -- 交易类别代码
    ,tran_type_cd varchar2(30) -- 转接类型代码
    ,curr_cd varchar2(30) -- 币种代码
    ,tot_tran_amt number(30,2) -- 总交易金额
    ,tot_tran_cnt number(30) -- 总交易笔数
    ,fail_amt number(30,2) -- 失败金额
    ,fail_cnt number(30) -- 失败笔数
    ,sucs_amt number(30,2) -- 成功金额
    ,sucs_cnt number(22) -- 成功笔数
    ,plat_return_code varchar2(30) -- 平台返回码
    ,plat_return_descb varchar2(500) -- 平台返回描述
    ,src_agt_id varchar2(100) -- 源协议编号
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,fee_id varchar2(100) -- 费用编号
    ,fee_descb varchar2(500) -- 费用描述
    ,inside_acct_flg varchar2(10) -- 内部户标志
    ,intnal_acct_id varchar2(100) -- 内部账户编号
    ,intnal_acct_name varchar2(500) -- 内部账户名称
    ,corp_acct_id varchar2(100) -- 对公账户编号
    ,corp_acct_name varchar2(500) -- 对公账户名称
    ,sign_flg varchar2(10) -- 签约标志
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,final_update_dt date -- 最后更新日期
    ,remark varchar2(500) -- 备注
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_ppps_tran_batch_info to ${icl_schema};
grant select on ${iml_schema}.agt_ppps_tran_batch_info to ${idl_schema};
grant select on ${iml_schema}.agt_ppps_tran_batch_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ppps_tran_batch_info is 'PPPS交易批次信息';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.chn_tran_flow_num is '渠道交易流水号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.chn_tran_dt is '渠道交易日期';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.mercht_id is '商户编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.chn_sys_cd is '渠道系统代码';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.tran_batch_no is '交易批次号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.tran_batch_status_cd is '交易批次状态代码';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.sys_id is '系统编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.tran_cate_cd is '交易类别代码';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.tran_type_cd is '转接类型代码';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.tot_tran_amt is '总交易金额';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.tot_tran_cnt is '总交易笔数';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.fail_amt is '失败金额';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.fail_cnt is '失败笔数';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.sucs_amt is '成功金额';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.sucs_cnt is '成功笔数';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.plat_return_code is '平台返回码';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.plat_return_descb is '平台返回描述';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.fee_id is '费用编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.fee_descb is '费用描述';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.inside_acct_flg is '内部户标志';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.intnal_acct_id is '内部账户编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.intnal_acct_name is '内部账户名称';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.corp_acct_id is '对公账户编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.corp_acct_name is '对公账户名称';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.sign_flg is '签约标志';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.remark is '备注';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ppps_tran_batch_info.etl_timestamp is 'ETL处理时间戳';
