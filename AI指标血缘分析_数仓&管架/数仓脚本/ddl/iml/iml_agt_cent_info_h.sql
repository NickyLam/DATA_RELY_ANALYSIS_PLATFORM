/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_cent_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_cent_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_cent_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cent_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,seq_num varchar2(60) -- 序号
    ,cust_id varchar2(100) -- 客户编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,sys_sub_flow_num varchar2(250) -- 系统子流水号
    ,evt_cate_cd varchar2(30) -- 事件类别代码
    ,cent_type_cd varchar2(30) -- 分位处理类型代码
    ,cent number(30,2) -- 分位金额
    ,curr_cd varchar2(30) -- 币种代码
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,tran_code varchar2(30) -- 交易码
    ,tran_dt date -- 交易日期
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,revs_flg varchar2(10) -- 冲正标志
    ,revs_flow_num varchar2(100) -- 冲正流水号
    ,revs_tran_code varchar2(100) -- 冲正交易码
    ,revs_tran_dt date -- 冲正交易日期
    ,revs_teller_id varchar2(100) -- 冲正柜员编号
    ,erase_acct_flg varchar2(10) -- 冲抹标志
    ,revs_rs varchar2(500) -- 冲正原因
    ,tran_tm date -- 交易时间
    ,clos_acct_flg varchar2(10) -- 销户标志
    ,init_chn_flow_num varchar2(100) -- 原渠道流水号
    ,init_chn_sub_flow_num varchar2(100) -- 原渠道子流水号
    ,init_tran_amt number(30,2) -- 原交易金额
    ,init_tran_dt date -- 原交易日期
    ,main_module_cd varchar2(30) -- 主模块代码
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
grant select on ${iml_schema}.agt_cent_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_cent_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_cent_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_cent_info_h is '分位金额处理信息历史';
comment on column ${iml_schema}.agt_cent_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_cent_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_cent_info_h.seq_num is '序号';
comment on column ${iml_schema}.agt_cent_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_cent_info_h.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_cent_info_h.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.agt_cent_info_h.sys_sub_flow_num is '系统子流水号';
comment on column ${iml_schema}.agt_cent_info_h.evt_cate_cd is '事件类别代码';
comment on column ${iml_schema}.agt_cent_info_h.cent_type_cd is '分位处理类型代码';
comment on column ${iml_schema}.agt_cent_info_h.cent is '分位金额';
comment on column ${iml_schema}.agt_cent_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_cent_info_h.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.agt_cent_info_h.tran_code is '交易码';
comment on column ${iml_schema}.agt_cent_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_cent_info_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.agt_cent_info_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_cent_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_cent_info_h.revs_flg is '冲正标志';
comment on column ${iml_schema}.agt_cent_info_h.revs_flow_num is '冲正流水号';
comment on column ${iml_schema}.agt_cent_info_h.revs_tran_code is '冲正交易码';
comment on column ${iml_schema}.agt_cent_info_h.revs_tran_dt is '冲正交易日期';
comment on column ${iml_schema}.agt_cent_info_h.revs_teller_id is '冲正柜员编号';
comment on column ${iml_schema}.agt_cent_info_h.erase_acct_flg is '冲抹标志';
comment on column ${iml_schema}.agt_cent_info_h.revs_rs is '冲正原因';
comment on column ${iml_schema}.agt_cent_info_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_cent_info_h.clos_acct_flg is '销户标志';
comment on column ${iml_schema}.agt_cent_info_h.init_chn_flow_num is '原渠道流水号';
comment on column ${iml_schema}.agt_cent_info_h.init_chn_sub_flow_num is '原渠道子流水号';
comment on column ${iml_schema}.agt_cent_info_h.init_tran_amt is '原交易金额';
comment on column ${iml_schema}.agt_cent_info_h.init_tran_dt is '原交易日期';
comment on column ${iml_schema}.agt_cent_info_h.main_module_cd is '主模块代码';
comment on column ${iml_schema}.agt_cent_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_cent_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_cent_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_cent_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_cent_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_cent_info_h.etl_timestamp is 'ETL处理时间戳';
