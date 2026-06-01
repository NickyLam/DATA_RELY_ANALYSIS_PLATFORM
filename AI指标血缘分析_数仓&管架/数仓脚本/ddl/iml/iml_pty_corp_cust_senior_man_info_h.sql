/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_corp_cust_senior_man_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_corp_cust_senior_man_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_corp_cust_senior_man_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_corp_cust_senior_man_info_h(
    party_id varchar2(100) -- 当事人编号
    ,lp_id varchar2(100) -- 法人编号
    ,party_name varchar2(500) -- 当事人名称
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,party_rela_type_cd varchar2(30) -- 关联关系类型代码
    ,gender_cd varchar2(30) -- 性别代码
    ,birth_dt date -- 出生日期
    ,edu_cd varchar2(30) -- 学历代码
    ,work_resume_descb varchar2(1000) -- 工作简历描述
    ,phone_num varchar2(60) -- 联系电话号码
    ,serving_dt date -- 任职日期
    ,indus_obtain_emply_years number(10) -- 行业从业年限
    ,hold_stock_situ_descb varchar2(500) -- 持股情况描述
    ,remark varchar2(500) -- 备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
    ,share_ratio number(18,6) -- 持股比例
    ,title_cd varchar2(30) -- 职称代码
    ,work_tel_num varchar2(60) -- 单位电话号码
    ,valid_flg varchar2(10) -- 有效标志
    ,nation_cd varchar2(30) -- 国籍代码
    ,corp_actl_ctrler_flg varchar2(10) -- 企业实际控制人标志
    ,senior_man_type_cd varchar2(30) -- 高管类型代码
    ,senior_man_career_cd varchar2(30) -- 高管职业代码
    ,cust_id varchar2(100) -- 客户编号
    ,rela_ps_cust_id varchar2(100) -- 关联人客户编号
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
grant select on ${iml_schema}.pty_corp_cust_senior_man_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_corp_cust_senior_man_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_corp_cust_senior_man_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_corp_cust_senior_man_info_h is '公司客户高管信息历史';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.party_name is '当事人名称';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.party_rela_type_cd is '关联关系类型代码';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.gender_cd is '性别代码';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.birth_dt is '出生日期';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.edu_cd is '学历代码';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.work_resume_descb is '工作简历描述';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.phone_num is '联系电话号码';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.serving_dt is '任职日期';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.indus_obtain_emply_years is '行业从业年限';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.hold_stock_situ_descb is '持股情况描述';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.remark is '备注';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.share_ratio is '持股比例';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.title_cd is '职称代码';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.work_tel_num is '单位电话号码';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.valid_flg is '有效标志';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.nation_cd is '国籍代码';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.corp_actl_ctrler_flg is '企业实际控制人标志';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.senior_man_type_cd is '高管类型代码';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.senior_man_career_cd is '高管职业代码';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.rela_ps_cust_id is '关联人客户编号';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_corp_cust_senior_man_info_h.etl_timestamp is 'ETL处理时间戳';
