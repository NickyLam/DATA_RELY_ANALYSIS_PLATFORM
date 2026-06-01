/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_cust_family_mem_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_cust_family_mem_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_cust_family_mem_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cust_family_mem_info_h(
    party_id varchar2(100) -- 当事人编号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_id varchar2(100) -- 客户编号
    ,main_cust_id varchar2(100) -- 主客户编号
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,family_mem_name varchar2(500) -- 家族成员姓名
    ,party_rela_type_cd varchar2(30) -- 关联关系类型代码
    ,local_corp_name varchar2(500) -- 所在企业名称
    ,local_corp_loan_card_no varchar2(60) -- 所在企业贷款卡号
    ,work_tel_num varchar2(60) -- 单位电话号码
    ,remark varchar2(1000) -- 备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
    ,addr varchar2(500) -- 地址
    ,corp_addr varchar2(500) -- 公司地址
    ,mon_inco number(30,2) -- 月收入
    ,phone_num varchar2(60) -- 联系电话号码
    ,join_work_year date -- 参加工作年份
    ,area_cd varchar2(60) -- 区号
    ,birth_dt date -- 出生日期
    ,landine_no varchar2(60) -- 座机号码
    ,edu_cd varchar2(30) -- 学历代码
    ,move_flg varchar2(10) -- 迁移标志
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
grant select on ${iml_schema}.pty_cust_family_mem_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_cust_family_mem_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_cust_family_mem_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_cust_family_mem_info_h is '客户家族成员信息历史';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.main_cust_id is '主客户编号';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.family_mem_name is '家族成员姓名';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.party_rela_type_cd is '关联关系类型代码';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.local_corp_name is '所在企业名称';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.local_corp_loan_card_no is '所在企业贷款卡号';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.work_tel_num is '单位电话号码';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.remark is '备注';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.addr is '地址';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.corp_addr is '公司地址';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.mon_inco is '月收入';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.phone_num is '联系电话号码';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.join_work_year is '参加工作年份';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.area_cd is '区号';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.birth_dt is '出生日期';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.landine_no is '座机号码';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.edu_cd is '学历代码';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.move_flg is '迁移标志';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_cust_family_mem_info_h.etl_timestamp is 'ETL处理时间戳';
