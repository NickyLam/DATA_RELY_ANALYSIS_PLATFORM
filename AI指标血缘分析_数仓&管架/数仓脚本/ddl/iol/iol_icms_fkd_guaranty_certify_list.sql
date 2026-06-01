/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fkd_guaranty_certify_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fkd_guaranty_certify_list
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fkd_guaranty_certify_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_guaranty_certify_list(
    serialno varchar2(32) -- 主键
    ,relativeserialno varchar2(33) -- 业务流水号
    ,warrantsduedt varchar2(10) -- 到期日
    ,guarantyimmovables varchar2(2) -- 权属人不动产共有情况
    ,guarantyperiodint varchar2(10) -- 使用年限
    ,guarantyrightid varchar2(300) -- 房权证号
    ,guarantyamount varchar2(20) -- 土地面积
    ,projectid varchar2(32) -- 楼盘编号
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,guarantyownshare number(16,9) -- 权属人共有份额
    ,guarantydate date -- 土地使用权起始日期
    ,pledgepkno varchar2(32) -- 质押物信息表主键
    ,guarantycertify varchar2(100) -- 权属证明
    ,guarantypurpers varchar2(200) -- 土地用途
    ,warrantstyp varchar2(10) -- 权证类型
    ,guarantyname varchar2(200) -- 权属人名称
    ,guarantyidno varchar2(20) -- 权属人身份证号
    ,guarantylocation varchar2(500) -- 土地位置
    ,guarantyid varchar2(32) -- 权属人编号
    ,guarantytype varchar2(10) -- 权利人类型
    ,guarantycerttype varchar2(10) -- 权利人证件类型
    ,guarantyrelative varchar2(10) -- 权利人与借款人关系
    ,guarantytelno varchar2(32) -- 权利人手机号码
    ,guarantycertmaturity date -- 证件号码到期日
    ,guarantytradematurity date -- 抵押企业营业期限到期日
    ,guarantymarriage varchar2(10) -- 权利人婚姻状况
    ,guarantysex varchar2(32) -- 权利人性别
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
grant select on ${iol_schema}.icms_fkd_guaranty_certify_list to ${iml_schema};
grant select on ${iol_schema}.icms_fkd_guaranty_certify_list to ${icl_schema};
grant select on ${iol_schema}.icms_fkd_guaranty_certify_list to ${idl_schema};
grant select on ${iol_schema}.icms_fkd_guaranty_certify_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fkd_guaranty_certify_list is '房快贷权属证明列表';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.serialno is '主键';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.relativeserialno is '业务流水号';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.warrantsduedt is '到期日';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantyimmovables is '权属人不动产共有情况';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantyperiodint is '使用年限';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantyrightid is '房权证号';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantyamount is '土地面积';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.projectid is '楼盘编号';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantyownshare is '权属人共有份额';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantydate is '土地使用权起始日期';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.pledgepkno is '质押物信息表主键';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantycertify is '权属证明';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantypurpers is '土地用途';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.warrantstyp is '权证类型';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantyname is '权属人名称';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantyidno is '权属人身份证号';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantylocation is '土地位置';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantyid is '权属人编号';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantytype is '权利人类型';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantycerttype is '权利人证件类型';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantyrelative is '权利人与借款人关系';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantytelno is '权利人手机号码';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantycertmaturity is '证件号码到期日';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantytradematurity is '抵押企业营业期限到期日';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantymarriage is '权利人婚姻状况';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.guarantysex is '权利人性别';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fkd_guaranty_certify_list.etl_timestamp is 'ETL处理时间戳';
