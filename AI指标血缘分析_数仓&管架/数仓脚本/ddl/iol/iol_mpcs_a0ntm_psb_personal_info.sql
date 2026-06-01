/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0ntm_psb_personal_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0ntm_psb_personal_info
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0ntm_psb_personal_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_psb_personal_info(
    id number(22,0) -- id
    ,app_no varchar2(30) -- 申请件编号
    ,certi_type varchar2(2) -- 证件类型
    ,certi_no varchar2(27) -- 身份证号
    ,name varchar2(135) -- 姓名
    ,sex varchar2(2) -- 性别
    ,birth_date date -- 出生日期
    ,marrystate varchar2(3) -- 婚姻状况
    ,mobile varchar2(30) -- 手机号码
    ,homephone varchar2(45) -- 家庭电话
    ,compphone varchar2(45) -- 单位电话
    ,qualification varchar2(3) -- 学历
    ,degree varchar2(3) -- 学位
    ,address varchar2(1050) -- 通讯地址
    ,reside_addr varchar2(1050) -- 户籍地址
    ,mate_certp varchar2(2) -- 配偶证件类型
    ,mate_cerno varchar2(27) -- 配偶证件号码
    ,mate_name varchar2(45) -- 配偶姓名
    ,mate_corp varchar2(750) -- 配偶工作单位
    ,mate_phone varchar2(45) -- 配偶联系电话
    ,addr varchar2(1050) -- 居住地址
    ,reside_state varchar2(3) -- 居住状况
    ,comp_nm varchar2(1050) -- 工作单位
    ,comp_addr varchar2(1050) -- 单位地址
    ,profess varchar2(3) -- 职业
    ,comp_trade varchar2(3) -- 行业
    ,business varchar2(3) -- 职务
    ,teach_pose varchar2(3) -- 职称
    ,work_date varchar2(6) -- 本单位工作起始年份
    ,infodate date -- 信息更新日期
    ,create_time date -- 创建时间
    ,batchfilename varchar2(90) -- 批量文件名
    ,seqno varchar2(30) -- 序列号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a0ntm_psb_personal_info to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0ntm_psb_personal_info to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_psb_personal_info to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_psb_personal_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0ntm_psb_personal_info is '身份信息';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.id is 'id';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.app_no is '申请件编号';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.certi_type is '证件类型';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.certi_no is '身份证号';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.name is '姓名';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.sex is '性别';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.birth_date is '出生日期';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.marrystate is '婚姻状况';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.mobile is '手机号码';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.homephone is '家庭电话';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.compphone is '单位电话';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.qualification is '学历';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.degree is '学位';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.address is '通讯地址';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.reside_addr is '户籍地址';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.mate_certp is '配偶证件类型';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.mate_cerno is '配偶证件号码';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.mate_name is '配偶姓名';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.mate_corp is '配偶工作单位';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.mate_phone is '配偶联系电话';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.addr is '居住地址';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.reside_state is '居住状况';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.comp_nm is '工作单位';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.comp_addr is '单位地址';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.profess is '职业';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.comp_trade is '行业';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.business is '职务';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.teach_pose is '职称';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.work_date is '本单位工作起始年份';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.infodate is '信息更新日期';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.create_time is '创建时间';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0ntm_psb_personal_info.etl_timestamp is 'ETL处理时间戳';
