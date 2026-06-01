/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_log_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_log_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_log_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_log_info(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_agt_id varchar2(100) -- 源协议编号
    ,log_bus_id varchar2(60) -- 保函业务编号
    ,tran_descb varchar2(375) -- 交易描述
    ,log_effect_dt date -- 保函生效日期
    ,full_amt_pay_dt date -- 全额付款日期
    ,indent_dt date -- 订单日期
    ,log_invalid_dt date -- 保函失效日期
    ,cty_rg_cd varchar2(30) -- 国家和地区代码
    ,edit_id varchar2(60) -- 版本编号
    ,log_open_type_cd varchar2(30) -- 保函开立类型代码
    ,cont_id varchar2(60) -- 合同编号
    ,cancel_rs_cd varchar2(30) -- 取消原因代码
    ,decrs_lmt_amt number(18,6) -- 减额金额
    ,decrs_lmt_curr_cd varchar2(30) -- 减额币种代码
    ,decrs_lmt_dt date -- 减额日期
    ,bal_curr_cd varchar2(30) -- 余额币种代码
    ,bal number(18,6) -- 余额
    ,acpt_flg varchar2(10) -- 承兑标志
    ,acpt_ratio number(18,6) -- 承兑比例
    ,open_dt date -- 开立日期
    ,acpt_way_cd varchar2(30) -- 承兑方式代码
    ,log_kind_cd varchar2(30) -- 保函种类代码
    ,charge_dt date -- 收费日期
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,decrs_lmt_flg varchar2(10) -- 减额标志
    ,margin_recvbl_ratio number(18,6) -- 保证金应收比例
    ,mtg_bus_flg varchar2(10) -- 货押业务标志
    ,dubil_id varchar2(60) -- 借据编号
    ,margin_actl_recv_ratio number(18,6) -- 保证金实收比例
    ,fin_log_flg varchar2(10) -- 融资性保函标志
    ,open_type_cd varchar2(30) -- 开立类型代码
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_log_info to ${icl_schema};
grant select on ${iml_schema}.agt_log_info to ${idl_schema};
grant select on ${iml_schema}.agt_log_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_log_info is '保函信息';
comment on column ${iml_schema}.agt_log_info.agt_id is '协议编号';
comment on column ${iml_schema}.agt_log_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_log_info.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_log_info.log_bus_id is '保函业务编号';
comment on column ${iml_schema}.agt_log_info.tran_descb is '交易描述';
comment on column ${iml_schema}.agt_log_info.log_effect_dt is '保函生效日期';
comment on column ${iml_schema}.agt_log_info.full_amt_pay_dt is '全额付款日期';
comment on column ${iml_schema}.agt_log_info.indent_dt is '订单日期';
comment on column ${iml_schema}.agt_log_info.log_invalid_dt is '保函失效日期';
comment on column ${iml_schema}.agt_log_info.cty_rg_cd is '国家和地区代码';
comment on column ${iml_schema}.agt_log_info.edit_id is '版本编号';
comment on column ${iml_schema}.agt_log_info.log_open_type_cd is '保函开立类型代码';
comment on column ${iml_schema}.agt_log_info.cont_id is '合同编号';
comment on column ${iml_schema}.agt_log_info.cancel_rs_cd is '取消原因代码';
comment on column ${iml_schema}.agt_log_info.decrs_lmt_amt is '减额金额';
comment on column ${iml_schema}.agt_log_info.decrs_lmt_curr_cd is '减额币种代码';
comment on column ${iml_schema}.agt_log_info.decrs_lmt_dt is '减额日期';
comment on column ${iml_schema}.agt_log_info.bal_curr_cd is '余额币种代码';
comment on column ${iml_schema}.agt_log_info.bal is '余额';
comment on column ${iml_schema}.agt_log_info.acpt_flg is '承兑标志';
comment on column ${iml_schema}.agt_log_info.acpt_ratio is '承兑比例';
comment on column ${iml_schema}.agt_log_info.open_dt is '开立日期';
comment on column ${iml_schema}.agt_log_info.acpt_way_cd is '承兑方式代码';
comment on column ${iml_schema}.agt_log_info.log_kind_cd is '保函种类代码';
comment on column ${iml_schema}.agt_log_info.charge_dt is '收费日期';
comment on column ${iml_schema}.agt_log_info.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_log_info.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_log_info.decrs_lmt_flg is '减额标志';
comment on column ${iml_schema}.agt_log_info.margin_recvbl_ratio is '保证金应收比例';
comment on column ${iml_schema}.agt_log_info.mtg_bus_flg is '货押业务标志';
comment on column ${iml_schema}.agt_log_info.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_log_info.margin_actl_recv_ratio is '保证金实收比例';
comment on column ${iml_schema}.agt_log_info.fin_log_flg is '融资性保函标志';
comment on column ${iml_schema}.agt_log_info.open_type_cd is '开立类型代码';
comment on column ${iml_schema}.agt_log_info.create_dt is '创建日期';
comment on column ${iml_schema}.agt_log_info.update_dt is '更新日期';
comment on column ${iml_schema}.agt_log_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_log_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_log_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_log_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_log_info.etl_timestamp is 'ETL处理时间戳';
