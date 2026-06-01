/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_corp_cust_group_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_corp_cust_group_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_corp_cust_group_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_corp_cust_group_info_h(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,belong_group_id varchar2(60) -- 所属集团编号
    ,data_src_cd varchar2(10) -- 数据来源代码
    ,belong_group_name varchar2(200) -- 所属集团名称
    ,belong_group_orgnz_cd varchar2(60) -- 所属集团组织机构代码
    ,belong_group_loan_card_no varchar2(60) -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd varchar2(30) -- 所属集团注册国家地区代码
    ,belong_group_site_cd varchar2(30) -- 所属集团所在地代码
    ,belong_group_rgst_addr varchar2(500) -- 所属集团注册地址
    ,group_core_mem_flg varchar2(10) -- 集团核心成员标志
    ,belong_group_dom_work_addr varchar2(500) -- 所属集团国内办公地址
    ,mem_type_cd varchar2(10) -- 成员类型代码
    ,parent_corp_flg varchar2(30) -- 母公司标志
    ,mem_status_cd varchar2(30) -- 成员状态代码
    ,use_family_edit_num varchar2(60) -- 当前使用的家谱版本号
    ,matn_family_edit_num varchar2(60) -- 当前维护的家谱版本号
    ,group_cust_type_cd varchar2(30) -- 集团客户类型代码
    ,mem_corp_name varchar2(500) -- 成员单位名称
    ,parent_mem_id varchar2(100) -- 父成员编号
    ,parent_mem_rela_type_cd varchar2(30) -- 父成员关系类型代码
    ,share_ratio number(38,8) -- 持股比例
    ,chg_type_cd varchar2(30) -- 修订类型代码
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
    ,update_org_id varchar2(100) -- 更新机构编号
    ,update_teller_id varchar2(100) -- 更新柜员编号
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
grant select on ${iml_schema}.pty_corp_cust_group_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_corp_cust_group_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_corp_cust_group_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_corp_cust_group_info_h is '对公客户集团信息历史';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.belong_group_id is '所属集团编号';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.data_src_cd is '数据来源代码';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.belong_group_name is '所属集团名称';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.belong_group_orgnz_cd is '所属集团组织机构代码';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.belong_group_loan_card_no is '所属集团贷款卡号';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.belong_group_rgst_cty_rg_cd is '所属集团注册国家地区代码';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.belong_group_site_cd is '所属集团所在地代码';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.belong_group_rgst_addr is '所属集团注册地址';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.group_core_mem_flg is '集团核心成员标志';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.belong_group_dom_work_addr is '所属集团国内办公地址';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.mem_type_cd is '成员类型代码';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.parent_corp_flg is '母公司标志';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.mem_status_cd is '成员状态代码';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.use_family_edit_num is '当前使用的家谱版本号';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.matn_family_edit_num is '当前维护的家谱版本号';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.group_cust_type_cd is '集团客户类型代码';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.mem_corp_name is '成员单位名称';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.parent_mem_id is '父成员编号';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.parent_mem_rela_type_cd is '父成员关系类型代码';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.share_ratio is '持股比例';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.chg_type_cd is '修订类型代码';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_corp_cust_group_info_h.etl_timestamp is 'ETL处理时间戳';
