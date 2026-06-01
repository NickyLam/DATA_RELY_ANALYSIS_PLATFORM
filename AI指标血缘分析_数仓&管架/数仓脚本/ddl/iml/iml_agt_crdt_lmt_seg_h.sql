/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_crdt_lmt_seg_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_crdt_lmt_seg_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_crdt_lmt_seg_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_crdt_lmt_seg_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,seg_lmt_id varchar2(100) -- 切分额度编号
    ,lmt_id varchar2(100) -- 额度编号
    ,up_level_seg_lmt_id varchar2(100) -- 上层切分额度编号
    ,seg_type_cd varchar2(100) -- 切分类型代码
    ,curr_cd varchar2(100) -- 币种代码
    ,spcl_seg_lmt_flg varchar2(10) -- 专项切分额度标志
    ,circl_flg varchar2(10) -- 循环标志
    ,seg_obj_id varchar2(2000) -- 切分对象编号
    ,seg_obj_type_name varchar2(2000) -- 切分对象类型名称
    ,seg_open_amt number(30,6) -- 切分敞口金额
    ,seg_nmal_amt number(30,6) -- 切分名义金额
    ,ocup_nmal_amt number(30,6) -- 占用名义金额
    ,ocup_open_amt number(30,6) -- 占用敞口金额
    ,aval_nmal_amt number(30,6) -- 可用名义金额
    ,aval_open_amt number(30,6) -- 可用敞口金额
    ,comn_open_amt number(30,6) -- 一般敞口金额
    ,comn_risk_aval_open_amt number(30,6) -- 一般风险可用敞口金额
    ,class_low_risk_open_amt number(30,6) -- 类低风险敞口金额
    ,class_low_risk_aval_open_amt number(30,6) -- 类低风险可用敞口金额
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_crdt_lmt_seg_h to ${icl_schema};
grant select on ${iml_schema}.agt_crdt_lmt_seg_h to ${idl_schema};
grant select on ${iml_schema}.agt_crdt_lmt_seg_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_crdt_lmt_seg_h is '授信额度切分历史';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.seg_lmt_id is '切分额度编号';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.lmt_id is '额度编号';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.up_level_seg_lmt_id is '上层切分额度编号';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.seg_type_cd is '切分类型代码';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.spcl_seg_lmt_flg is '专项切分额度标志';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.circl_flg is '循环标志';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.seg_obj_id is '切分对象编号';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.seg_obj_type_name is '切分对象类型名称';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.seg_open_amt is '切分敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.seg_nmal_amt is '切分名义金额';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.ocup_nmal_amt is '占用名义金额';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.ocup_open_amt is '占用敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.aval_nmal_amt is '可用名义金额';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.aval_open_amt is '可用敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.comn_open_amt is '一般敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.comn_risk_aval_open_amt is '一般风险可用敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.class_low_risk_open_amt is '类低风险敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.class_low_risk_aval_open_amt is '类低风险可用敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_crdt_lmt_seg_h.etl_timestamp is 'ETL处理时间戳';
