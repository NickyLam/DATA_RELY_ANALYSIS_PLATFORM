/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_rcd_ir_tzbl_jbxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_rcd_ir_tzbl_jbxx
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_rcd_ir_tzbl_jbxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_rcd_ir_tzbl_jbxx(
    key_id varchar2(60) -- 主键
    ,data_dt varchar2(10) -- 数据日期
    ,loan_no varchar2(60) -- 借据号
    ,cust_id varchar2(60) -- 客户证件号码
    ,cust_name varchar2(100) -- 客户名称
    ,pty_typ_cd varchar2(8) -- 客户类型代码
    ,pty_blng_indu_cd varchar2(10) -- 客户所属行业代码
    ,pty_loc_cd varchar2(8) -- 客户所在地代码
    ,non_resident_flg varchar2(1) -- 非居民标志
    ,farmer_flg varchar2(1) -- 农户标志
    ,indv_indu_com_acct_flg varchar2(1) -- 个体工商户标志
    ,pty_status_cd varchar2(8) -- 客户状态代码
    ,age number -- 年龄
    ,valid_gender_cd varchar2(1) -- 性别
    ,native_place_cd varchar2(300) -- 籍贯代码
    ,nation_cd varchar2(8) -- 国籍代码
    ,poli_face_cd varchar2(8) -- 政治面貌代码
    ,marriage_status_cd varchar2(8) -- 婚姻状况代码
    ,highest_edu_degree_cd varchar2(8) -- 最高学历代码
    ,reside_status_cd varchar2(8) -- 居住状况代码
    ,join_work_year number -- 参加工作年限
    ,join_enterprise_year number -- 加入现单位年限
    ,corp_blng_indu_cd varchar2(10) -- 单位所属行业代码
    ,corp_prop_cd varchar2(8) -- 单位性质代码
    ,profsn_title_cd varchar2(1) -- 职称代码
    ,ghb_emp_flg varchar2(1) -- 本行员工标志
    ,ghb_shrholder_flg varchar2(1) -- 本行股东标志
    ,raise_cnt number(10) -- 供养人数
    ,family_anl_inc number(18,4) -- 家庭年收入
    ,family_mon_income number(18,4) -- 家庭月收入
    ,indv_mon_income number(18,4) -- 个人月收入
    ,indv_year_income number(18,4) -- 个人年收入
    ,blkl_pty_flg varchar2(1) -- 黑名单客户标志
    ,crdt_pty_flg varchar2(1) -- 授信客户标志
    ,small_eown_flg varchar2(1) -- 小微企业主标志
    ,pty_level_cd varchar2(1) -- 客户级别代码
    ,insd_and_otsd_flg varchar2(1) -- 境内外标志
    ,work_stus varchar2(40) -- 雇佣状态
    ,house_value number(18,4) -- 房产价值
    ,exc_id varchar2(60) -- 执行清单表ID
    ,generated_time date -- 生成时间
    ,partition_month varchar2(60) -- 分区月份
    ,cust_no varchar2(60) -- 客户编码
    ,serial_no varchar2(64) -- 业务流水号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_jbxx to ${iml_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_jbxx to ${icl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_jbxx to ${idl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_jbxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_rcd_ir_tzbl_jbxx is '特征变量表_基本信息';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.key_id is '主键';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.data_dt is '数据日期';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.loan_no is '借据号';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.cust_id is '客户证件号码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.cust_name is '客户名称';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.pty_typ_cd is '客户类型代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.pty_blng_indu_cd is '客户所属行业代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.pty_loc_cd is '客户所在地代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.non_resident_flg is '非居民标志';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.farmer_flg is '农户标志';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.indv_indu_com_acct_flg is '个体工商户标志';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.pty_status_cd is '客户状态代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.age is '年龄';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.valid_gender_cd is '性别';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.native_place_cd is '籍贯代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.nation_cd is '国籍代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.poli_face_cd is '政治面貌代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.marriage_status_cd is '婚姻状况代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.highest_edu_degree_cd is '最高学历代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.reside_status_cd is '居住状况代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.join_work_year is '参加工作年限';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.join_enterprise_year is '加入现单位年限';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.corp_blng_indu_cd is '单位所属行业代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.corp_prop_cd is '单位性质代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.profsn_title_cd is '职称代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.ghb_emp_flg is '本行员工标志';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.ghb_shrholder_flg is '本行股东标志';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.raise_cnt is '供养人数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.family_anl_inc is '家庭年收入';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.family_mon_income is '家庭月收入';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.indv_mon_income is '个人月收入';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.indv_year_income is '个人年收入';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.blkl_pty_flg is '黑名单客户标志';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.crdt_pty_flg is '授信客户标志';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.small_eown_flg is '小微企业主标志';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.pty_level_cd is '客户级别代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.insd_and_otsd_flg is '境内外标志';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.work_stus is '雇佣状态';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.house_value is '房产价值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.exc_id is '执行清单表ID';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.generated_time is '生成时间';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.partition_month is '分区月份';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.cust_no is '客户编码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.serial_no is '业务流水号';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_jbxx.etl_timestamp is 'ETL处理时间戳';
