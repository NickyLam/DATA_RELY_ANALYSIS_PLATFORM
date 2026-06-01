/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_white_list_cust_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_white_list_cust_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_white_list_cust_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_white_list_cust_info_h(
    seq_num varchar2(100) -- 序号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,lp_id varchar2(100) -- 法人编号
    ,cert_no varchar2(100) -- 证件号码
    ,effect_dt date -- 生效日期
    ,exp_dt date -- 到期日期
    ,list_exchg_cd varchar2(30) -- 上市交易所代码
    ,list_src_cd varchar2(30) -- 名单来源代码
    ,list_cate_cd varchar2(30) -- 名单类别代码
    ,valid_flg varchar2(10) -- 有效标志
    ,inclu_rs_descb varchar2(500) -- 列入原因描述
    ,work_tel varchar2(60) -- 单位电话
    ,mobile_no varchar2(60) -- 手机号码
    ,src_descb varchar2(500) -- 来源描述
    ,blklist_apv_status_cd varchar2(60) -- 黑名单审批状态代码
    ,blklist_descb varchar2(500) -- 黑名单描述
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
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
grant select on ${iml_schema}.pty_white_list_cust_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_white_list_cust_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_white_list_cust_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_white_list_cust_info_h is '黑白名单客户信息历史';
comment on column ${iml_schema}.pty_white_list_cust_info_h.seq_num is '序号';
comment on column ${iml_schema}.pty_white_list_cust_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.pty_white_list_cust_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.pty_white_list_cust_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_white_list_cust_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.pty_white_list_cust_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.pty_white_list_cust_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.pty_white_list_cust_info_h.list_exchg_cd is '上市交易所代码';
comment on column ${iml_schema}.pty_white_list_cust_info_h.list_src_cd is '名单来源代码';
comment on column ${iml_schema}.pty_white_list_cust_info_h.list_cate_cd is '名单类别代码';
comment on column ${iml_schema}.pty_white_list_cust_info_h.valid_flg is '有效标志';
comment on column ${iml_schema}.pty_white_list_cust_info_h.inclu_rs_descb is '列入原因描述';
comment on column ${iml_schema}.pty_white_list_cust_info_h.work_tel is '单位电话';
comment on column ${iml_schema}.pty_white_list_cust_info_h.mobile_no is '手机号码';
comment on column ${iml_schema}.pty_white_list_cust_info_h.src_descb is '来源描述';
comment on column ${iml_schema}.pty_white_list_cust_info_h.blklist_apv_status_cd is '黑名单审批状态代码';
comment on column ${iml_schema}.pty_white_list_cust_info_h.blklist_descb is '黑名单描述';
comment on column ${iml_schema}.pty_white_list_cust_info_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.pty_white_list_cust_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.pty_white_list_cust_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.pty_white_list_cust_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.pty_white_list_cust_info_h.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.pty_white_list_cust_info_h.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.pty_white_list_cust_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.pty_white_list_cust_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_white_list_cust_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_white_list_cust_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_white_list_cust_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_white_list_cust_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_white_list_cust_info_h.etl_timestamp is 'ETL处理时间戳';
