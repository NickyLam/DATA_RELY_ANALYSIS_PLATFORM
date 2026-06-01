/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wld_dubil_attach_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wld_dubil_attach_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wld_dubil_attach_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_dubil_attach_info(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,batch_doc_name varchar2(375) -- 批量文件名称
    ,ser_num varchar2(20) -- 序列号
    ,batch_dt date -- 批量日期
    ,logic_card_no varchar2(60) -- 逻辑卡号
    ,dubil_id varchar2(60) -- 借据编号
    ,tran_plan_id varchar2(60) -- 转让计划编号
    ,tran_bf_init_syn_id varchar2(60) -- 转让前初始银团编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,exec_year_int_rat number(18,8) -- 执行年利率
    ,currt_lpr_val number(18,8) -- 当期LPR值
    ,lpr_pub_dt date -- LPR公布日期
    ,conti_owe_this_days number(22) -- 连续欠本天数
    ,conti_over_int_days number(22) -- 连续欠息天数
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
grant select on ${iml_schema}.agt_wld_dubil_attach_info to ${icl_schema};
grant select on ${iml_schema}.agt_wld_dubil_attach_info to ${idl_schema};
grant select on ${iml_schema}.agt_wld_dubil_attach_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wld_dubil_attach_info is '微粒贷借据补充信息';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.batch_doc_name is '批量文件名称';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.ser_num is '序列号';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.batch_dt is '批量日期';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.logic_card_no is '逻辑卡号';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.tran_plan_id is '转让计划编号';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.tran_bf_init_syn_id is '转让前初始银团编号';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.exec_year_int_rat is '执行年利率';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.currt_lpr_val is '当期LPR值';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.lpr_pub_dt is 'LPR公布日期';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.conti_owe_this_days is '连续欠本天数';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.conti_over_int_days is '连续欠息天数';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wld_dubil_attach_info.etl_timestamp is 'ETL处理时间戳';
