/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_epc_payfan_mercht_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_epc_payfan_mercht_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_epc_payfan_mercht_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_epc_payfan_mercht_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,ser_num varchar2(250) -- 序列号
    ,sign_acct_id varchar2(250) -- 签约账户编号
    ,sign_acct_name varchar2(500) -- 签约账户名称
    ,sign_acct_type_cd varchar2(30) -- 签约账户类型代码
    ,sign_status_cd varchar2(30) -- 签约状态代码
    ,sign_dt date -- 签约日期
    ,coll_acct_id varchar2(100) -- 归集账户编号
    ,coll_acct_name varchar2(500) -- 归集账户名称
    ,payfan_lmt number(30,2) -- 代付额度
    ,mercht_status_cd varchar2(30) -- 商户状态代码
    ,cotas_name varchar2(500) -- 联系人名称
    ,cotas_tel_num varchar2(250) -- 联系人电话号码
    ,mgmt_chn_cd varchar2(30) -- 管理渠道代码
    ,belong_brch_org_id varchar2(100) -- 所属分行机构编号
    ,valid_flg varchar2(10) -- 有效标志
    ,init_create_dt date -- 最初创建日期
    ,create_teller_id varchar2(100) -- 创建柜员编号
    ,create_teller_name varchar2(500) -- 创建柜员名称
    ,latest_update_dt date -- 最新更新日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_teller_name varchar2(500) -- 更新柜员名称
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
grant select on ${iml_schema}.agt_epc_payfan_mercht_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_epc_payfan_mercht_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_epc_payfan_mercht_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_epc_payfan_mercht_info_h is '网联代付商户信息历史';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.ser_num is '序列号';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.sign_acct_id is '签约账户编号';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.sign_acct_name is '签约账户名称';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.sign_acct_type_cd is '签约账户类型代码';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.sign_status_cd is '签约状态代码';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.sign_dt is '签约日期';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.coll_acct_id is '归集账户编号';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.coll_acct_name is '归集账户名称';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.payfan_lmt is '代付额度';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.mercht_status_cd is '商户状态代码';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.cotas_name is '联系人名称';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.cotas_tel_num is '联系人电话号码';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.mgmt_chn_cd is '管理渠道代码';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.belong_brch_org_id is '所属分行机构编号';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.valid_flg is '有效标志';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.init_create_dt is '最初创建日期';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.create_teller_id is '创建柜员编号';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.create_teller_name is '创建柜员名称';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.latest_update_dt is '最新更新日期';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.update_teller_name is '更新柜员名称';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_epc_payfan_mercht_info_h.etl_timestamp is 'ETL处理时间戳';
