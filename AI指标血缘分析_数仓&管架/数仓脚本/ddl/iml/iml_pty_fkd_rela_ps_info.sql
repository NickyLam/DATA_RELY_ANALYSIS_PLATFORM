/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_fkd_rela_ps_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_fkd_rela_ps_info
whenever sqlerror continue none;
drop table ${iml_schema}.pty_fkd_rela_ps_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_fkd_rela_ps_info(
    fkd_rela_ps_list_id varchar2(60) -- 房快贷关联人列表编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_flow_num varchar2(60) -- 业务流水号
    ,rela_ps_type_cd varchar2(30) -- 关联人类型代码
    ,rela_ps_name varchar2(100) -- 关联人姓名
    ,rela_ps_mobile_no varchar2(60) -- 关联人手机号码
    ,rela_ps_cert_type_cd varchar2(10) -- 关联人证件类型代码
    ,rela_ps_cert_no varchar2(60) -- 关联人证件号码
    ,and_main_brwer_rela_cd varchar2(10) -- 与主借款人关系代码
    ,rela_ps_resdnt_addr_city_cd varchar2(10) -- 关联人居住地址城市代码
    ,rela_ps_resdnt_addr varchar2(500) -- 关联人居住地址
    ,rela_ps_marriage_situ_cd varchar2(10) -- 关联人婚姻状况代码
    ,rela_ps_spouse_name varchar2(100) -- 关联人配偶姓名
    ,rela_ps_spouse_mobile_no varchar2(60) -- 关联人配偶手机号码
    ,rela_ps_spouse_cert_type_cd varchar2(10) -- 关联人配偶证件类型代码
    ,rela_ps_spouse_cert_no varchar2(60) -- 关联人配偶证件号码
    ,rela_ps_cert_exp_dt date -- 关联人证件到期日
    ,cust_id varchar2(60) -- 客户编号
    ,rev_fraud_rest varchar2(10) -- 反欺诈结果
    ,crdtc_rest varchar2(10) -- 征信结果
    ,cust_char_cd varchar2(30) -- 客户性质代码
    ,corp_max_nature_ps_shard_flg varchar2(10) -- 企业最大自然人股东标志
    ,farm_flg varchar2(10) -- 农户标志
    ,guartor_flg varchar2(10) -- 担保人标志
    ,mtg_ps_mtg_have_lot number(30,8) -- 抵押人对抵押物拥有的份额
    ,rel_esat_own_situ varchar2(500) -- 不动产共有情况
    ,rela_ps_nationty varchar2(500) -- 关联人民族
    ,rela_ps_nation_cd varchar2(30) -- 关联人国籍代码
    ,rela_ps_rpr_addr varchar2(500) -- 关联人户籍地址
    ,rela_ps_rpr_char varchar2(500) -- 关联人户籍性质
    ,rela_ps_gender_cd varchar2(30) -- 关联人性别代码
    ,rela_ps_edu_cd varchar2(30) -- 关联人学历代码
    ,brwer_and_group_rela_cd date -- 关联人证件起始日期
    ,rela_ps_cert_valid_dt date -- 关联人证件有效日期
    ,rela_ps_work_years number(30,8) -- 关联人工作年限
    ,rela_ps_at_mon_inco number(30,8) -- 关联人税后月收入
    ,rela_ps_career_cd varchar2(30) -- 关联人职业代码
    ,rela_ps_corp_addr varchar2(500) -- 关联人单位地址
    ,rela_ps_corp_char varchar2(500) -- 关联人单位性质
    ,rela_ps_corp_name varchar2(500) -- 关联人单位名称
    ,rela_ps_work_tel varchar2(60) -- 关联人单位电话
    ,rela_ps_spouse_career_cd varchar2(30) -- 关联人配偶职业代码
    ,rela_ps_spouse_cert_invalid_dt date -- 关联人配偶证件失效日期
    ,rela_ps_spouse_gender_cd varchar2(30) -- 关联人配偶性别代码
    ,rela_ps_spouse_nation_cd varchar2(30) -- 关联人配偶国籍代码
    ,rela_ps_spouse_resdnt_addr varchar2(500) -- 关联人配偶居住地址
    ,rela_ps_spouse_rpr_char_cd varchar2(30) -- 关联人配偶户籍性质代码
    ,rela_ps_have_house_flg varchar2(10) -- 关联人有房标志
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
grant select on ${iml_schema}.pty_fkd_rela_ps_info to ${icl_schema};
grant select on ${iml_schema}.pty_fkd_rela_ps_info to ${idl_schema};
grant select on ${iml_schema}.pty_fkd_rela_ps_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_fkd_rela_ps_info is '房快贷关联人信息';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.fkd_rela_ps_list_id is '房快贷关联人列表编号';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.lp_id is '法人编号';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_type_cd is '关联人类型代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_name is '关联人姓名';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_mobile_no is '关联人手机号码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_cert_type_cd is '关联人证件类型代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_cert_no is '关联人证件号码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.and_main_brwer_rela_cd is '与主借款人关系代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_resdnt_addr_city_cd is '关联人居住地址城市代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_resdnt_addr is '关联人居住地址';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_marriage_situ_cd is '关联人婚姻状况代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_spouse_name is '关联人配偶姓名';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_spouse_mobile_no is '关联人配偶手机号码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_spouse_cert_type_cd is '关联人配偶证件类型代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_spouse_cert_no is '关联人配偶证件号码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_cert_exp_dt is '关联人证件到期日';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.cust_id is '客户编号';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rev_fraud_rest is '反欺诈结果';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.crdtc_rest is '征信结果';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.cust_char_cd is '客户性质代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.corp_max_nature_ps_shard_flg is '企业最大自然人股东标志';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.farm_flg is '农户标志';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.guartor_flg is '担保人标志';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.mtg_ps_mtg_have_lot is '抵押人对抵押物拥有的份额';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rel_esat_own_situ is '不动产共有情况';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_nationty is '关联人民族';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_nation_cd is '关联人国籍代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_rpr_addr is '关联人户籍地址';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_rpr_char is '关联人户籍性质';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_gender_cd is '关联人性别代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_edu_cd is '关联人学历代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.brwer_and_group_rela_cd is '关联人证件起始日期';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_cert_valid_dt is '关联人证件有效日期';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_work_years is '关联人工作年限';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_at_mon_inco is '关联人税后月收入';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_career_cd is '关联人职业代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_corp_addr is '关联人单位地址';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_corp_char is '关联人单位性质';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_corp_name is '关联人单位名称';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_work_tel is '关联人单位电话';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_spouse_career_cd is '关联人配偶职业代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_spouse_cert_invalid_dt is '关联人配偶证件失效日期';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_spouse_gender_cd is '关联人配偶性别代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_spouse_nation_cd is '关联人配偶国籍代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_spouse_resdnt_addr is '关联人配偶居住地址';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_spouse_rpr_char_cd is '关联人配偶户籍性质代码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.rela_ps_have_house_flg is '关联人有房标志';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.start_dt is '开始时间';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.end_dt is '结束时间';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.id_mark is '增删标志';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.job_cd is '任务编码';
comment on column ${iml_schema}.pty_fkd_rela_ps_info.etl_timestamp is 'ETL处理时间戳';
