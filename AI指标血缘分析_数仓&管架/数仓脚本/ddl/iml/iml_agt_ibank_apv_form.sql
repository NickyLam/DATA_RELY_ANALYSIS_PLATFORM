/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ibank_apv_form
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ibank_apv_form
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ibank_apv_form purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ibank_apv_form(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,apv_form_num varchar2(60) -- 审批单号
    ,entr_tm timestamp -- 委托时间
    ,apv_status_cd varchar2(10) -- 审批状态代码
    ,apv_lmt number(38,8) -- 审批额度
    ,actl_ocup_lmt number(38,8) -- 实际占用额度
    ,surp_aval_lmt number(38,8) -- 剩余可用额度
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,apv_vp_cnt number(10) -- 审批有效期数
    ,incremt_lmt_flg varchar2(10) -- 增量限额标志
    ,apver_id varchar2(60) -- 审批人编号
    ,apver_name varchar2(150) -- 审批人名称
    ,rela_muti_tran_flg varchar2(10) -- 关联比条交易标志
    ,wrtoff_lmt number(38,8) -- 注销额度
    ,apv_form_type_cd varchar2(10) -- 审批单类型代码
    ,entr_bs_dir_cd varchar2(10) -- 委托买卖方向代码
    ,entr_asset_type_cd varchar2(30) -- 委托资产类型代码
    ,entr_asset_market_type_cd varchar2(30) -- 委托资产市场类型代码
    ,entr_portf_unit_id varchar2(60) -- 委托投组单元编号
    ,curr_cd varchar2(10) -- 币种代码
    ,entr_yld_rat number(30,8) -- 委托收益率
    ,entr_price number(38,8) -- 委托价格
    ,distrtd_lmt number(38,8) -- 已分发额度
    ,not_distrt_lmt number(38,8) -- 未分发额度
    ,termnt_lmt number(38,8) -- 终止额度
    ,execed_lmt number(38,8) -- 已执行额度
    ,not_exec_lmt number(38,8) -- 未执行额度
    ,tran_seq_num varchar2(60) -- 交易序号
    ,surp_apv_lmt number(38,8) -- 剩余审批额度
    ,ext_status_cd varchar2(10) -- 外部状态代码
    ,task_step_seq_num varchar2(60) -- 任务步骤序号
    ,revo_rtn_flg_cd varchar2(10) -- 撤销退回标志代码
    ,surp_quot_lmt number(38,8) -- 剩余报价额度
    ,rela_apv_form_num varchar2(60) -- 关联审批单号
    ,cm_attr_flg varchar2(60) -- 主从属性标志
    ,rela_attr_flg varchar2(60) -- 关联属性标志
    ,up_down_cd varchar2(10) -- 上下行代码
    ,match_mode_cd varchar2(10) -- 匹配模式代码
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
grant select on ${iml_schema}.agt_ibank_apv_form to ${icl_schema};
grant select on ${iml_schema}.agt_ibank_apv_form to ${idl_schema};
grant select on ${iml_schema}.agt_ibank_apv_form to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ibank_apv_form is '同业审批单';
comment on column ${iml_schema}.agt_ibank_apv_form.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ibank_apv_form.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ibank_apv_form.apv_form_num is '审批单号';
comment on column ${iml_schema}.agt_ibank_apv_form.entr_tm is '委托时间';
comment on column ${iml_schema}.agt_ibank_apv_form.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_ibank_apv_form.apv_lmt is '审批额度';
comment on column ${iml_schema}.agt_ibank_apv_form.actl_ocup_lmt is '实际占用额度';
comment on column ${iml_schema}.agt_ibank_apv_form.surp_aval_lmt is '剩余可用额度';
comment on column ${iml_schema}.agt_ibank_apv_form.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_ibank_apv_form.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_ibank_apv_form.apv_vp_cnt is '审批有效期数';
comment on column ${iml_schema}.agt_ibank_apv_form.incremt_lmt_flg is '增量限额标志';
comment on column ${iml_schema}.agt_ibank_apv_form.apver_id is '审批人编号';
comment on column ${iml_schema}.agt_ibank_apv_form.apver_name is '审批人名称';
comment on column ${iml_schema}.agt_ibank_apv_form.rela_muti_tran_flg is '关联比条交易标志';
comment on column ${iml_schema}.agt_ibank_apv_form.wrtoff_lmt is '注销额度';
comment on column ${iml_schema}.agt_ibank_apv_form.apv_form_type_cd is '审批单类型代码';
comment on column ${iml_schema}.agt_ibank_apv_form.entr_bs_dir_cd is '委托买卖方向代码';
comment on column ${iml_schema}.agt_ibank_apv_form.entr_asset_type_cd is '委托资产类型代码';
comment on column ${iml_schema}.agt_ibank_apv_form.entr_asset_market_type_cd is '委托资产市场类型代码';
comment on column ${iml_schema}.agt_ibank_apv_form.entr_portf_unit_id is '委托投组单元编号';
comment on column ${iml_schema}.agt_ibank_apv_form.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_ibank_apv_form.entr_yld_rat is '委托收益率';
comment on column ${iml_schema}.agt_ibank_apv_form.entr_price is '委托价格';
comment on column ${iml_schema}.agt_ibank_apv_form.distrtd_lmt is '已分发额度';
comment on column ${iml_schema}.agt_ibank_apv_form.not_distrt_lmt is '未分发额度';
comment on column ${iml_schema}.agt_ibank_apv_form.termnt_lmt is '终止额度';
comment on column ${iml_schema}.agt_ibank_apv_form.execed_lmt is '已执行额度';
comment on column ${iml_schema}.agt_ibank_apv_form.not_exec_lmt is '未执行额度';
comment on column ${iml_schema}.agt_ibank_apv_form.tran_seq_num is '交易序号';
comment on column ${iml_schema}.agt_ibank_apv_form.surp_apv_lmt is '剩余审批额度';
comment on column ${iml_schema}.agt_ibank_apv_form.ext_status_cd is '外部状态代码';
comment on column ${iml_schema}.agt_ibank_apv_form.task_step_seq_num is '任务步骤序号';
comment on column ${iml_schema}.agt_ibank_apv_form.revo_rtn_flg_cd is '撤销退回标志代码';
comment on column ${iml_schema}.agt_ibank_apv_form.surp_quot_lmt is '剩余报价额度';
comment on column ${iml_schema}.agt_ibank_apv_form.rela_apv_form_num is '关联审批单号';
comment on column ${iml_schema}.agt_ibank_apv_form.cm_attr_flg is '主从属性标志';
comment on column ${iml_schema}.agt_ibank_apv_form.rela_attr_flg is '关联属性标志';
comment on column ${iml_schema}.agt_ibank_apv_form.up_down_cd is '上下行代码';
comment on column ${iml_schema}.agt_ibank_apv_form.match_mode_cd is '匹配模式代码';
comment on column ${iml_schema}.agt_ibank_apv_form.create_dt is '创建日期';
comment on column ${iml_schema}.agt_ibank_apv_form.update_dt is '更新日期';
comment on column ${iml_schema}.agt_ibank_apv_form.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_ibank_apv_form.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ibank_apv_form.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ibank_apv_form.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ibank_apv_form.etl_timestamp is 'ETL处理时间戳';
