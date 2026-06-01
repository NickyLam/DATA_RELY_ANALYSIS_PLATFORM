/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_sxd_company_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_sxd_company_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_sxd_company_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_info(
    serno varchar2(32) -- 业务流水号
    ,yyqx varchar2(20) -- 营业期限(到期日)
    ,zcdz varchar2(300) -- 注册地址
    ,jyfw varchar2(3600) -- 经营范围
    ,fddbrmc varchar2(75) -- 法定代表人姓名
    ,frdydz varchar2(90) -- 法定代表人电子邮箱
    ,gszch varchar2(50) -- 工商注册号
    ,zjlx varchar2(2) -- 证件类型
    ,fryddhhm varchar2(60) -- 法定代表人移动电话号码
    ,hymxmc varchar2(60) -- 行业名称
    ,frgddhhm varchar2(60) -- 法定代表人电话号码
    ,xydj varchar2(1) -- 纳税信用等级
    ,dmgyxzqh varchar2(6) -- 企业注册地行政地区码
    ,nsrmc varchar2(300) -- 纳税人名称
    ,zczbze number(18,2) -- 注册资本
    ,frzjlxmc varchar2(4) -- 法定代表人证件类型
    ,frzjhm varchar2(30) -- 法定代表人证件号码
    ,zgswjgmc varchar2(200) -- 主管税务机关名称
    ,dhhm varchar2(40) -- 联系电话
    ,djrq date -- 登记（开业）日期
    ,sykjzddm varchar2(3) -- 适用会计制度
    ,migtflag varchar2(80) -- 
    ,scjydz varchar2(300) -- 营业地址
    ,hymxdm varchar2(4) -- 行业代码
    ,nsrlx varchar2(400) -- 纳税类型
    ,xypfsj date -- 评级时间
    ,nsrsbh varchar2(20) -- 纳税人识别号
    ,zzjgdm varchar2(20) -- 组织机构代码
    ,cyrs varchar2(10) -- 从业人数
    ,nsrzt varchar2(30) -- 纳税人状态
    ,ds varchar2(75) -- 企业所在市
    ,hzrq date -- 核准日期
    ,djzclxdm varchar2(3) -- 企业登记注册类型代码
    ,zcbzmc varchar2(3) -- 注册资本币种
    ,dmgyjdxz varchar2(9) -- 企业注册地街道地区码
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
grant select on ${iol_schema}.icms_sxd_company_info to ${iml_schema};
grant select on ${iol_schema}.icms_sxd_company_info to ${icl_schema};
grant select on ${iol_schema}.icms_sxd_company_info to ${idl_schema};
grant select on ${iol_schema}.icms_sxd_company_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_sxd_company_info is '税兴贷企业信息';
comment on column ${iol_schema}.icms_sxd_company_info.serno is '业务流水号';
comment on column ${iol_schema}.icms_sxd_company_info.yyqx is '营业期限(到期日)';
comment on column ${iol_schema}.icms_sxd_company_info.zcdz is '注册地址';
comment on column ${iol_schema}.icms_sxd_company_info.jyfw is '经营范围';
comment on column ${iol_schema}.icms_sxd_company_info.fddbrmc is '法定代表人姓名';
comment on column ${iol_schema}.icms_sxd_company_info.frdydz is '法定代表人电子邮箱';
comment on column ${iol_schema}.icms_sxd_company_info.gszch is '工商注册号';
comment on column ${iol_schema}.icms_sxd_company_info.zjlx is '证件类型';
comment on column ${iol_schema}.icms_sxd_company_info.fryddhhm is '法定代表人移动电话号码';
comment on column ${iol_schema}.icms_sxd_company_info.hymxmc is '行业名称';
comment on column ${iol_schema}.icms_sxd_company_info.frgddhhm is '法定代表人电话号码';
comment on column ${iol_schema}.icms_sxd_company_info.xydj is '纳税信用等级';
comment on column ${iol_schema}.icms_sxd_company_info.dmgyxzqh is '企业注册地行政地区码';
comment on column ${iol_schema}.icms_sxd_company_info.nsrmc is '纳税人名称';
comment on column ${iol_schema}.icms_sxd_company_info.zczbze is '注册资本';
comment on column ${iol_schema}.icms_sxd_company_info.frzjlxmc is '法定代表人证件类型';
comment on column ${iol_schema}.icms_sxd_company_info.frzjhm is '法定代表人证件号码';
comment on column ${iol_schema}.icms_sxd_company_info.zgswjgmc is '主管税务机关名称';
comment on column ${iol_schema}.icms_sxd_company_info.dhhm is '联系电话';
comment on column ${iol_schema}.icms_sxd_company_info.djrq is '登记（开业）日期';
comment on column ${iol_schema}.icms_sxd_company_info.sykjzddm is '适用会计制度';
comment on column ${iol_schema}.icms_sxd_company_info.migtflag is '';
comment on column ${iol_schema}.icms_sxd_company_info.scjydz is '营业地址';
comment on column ${iol_schema}.icms_sxd_company_info.hymxdm is '行业代码';
comment on column ${iol_schema}.icms_sxd_company_info.nsrlx is '纳税类型';
comment on column ${iol_schema}.icms_sxd_company_info.xypfsj is '评级时间';
comment on column ${iol_schema}.icms_sxd_company_info.nsrsbh is '纳税人识别号';
comment on column ${iol_schema}.icms_sxd_company_info.zzjgdm is '组织机构代码';
comment on column ${iol_schema}.icms_sxd_company_info.cyrs is '从业人数';
comment on column ${iol_schema}.icms_sxd_company_info.nsrzt is '纳税人状态';
comment on column ${iol_schema}.icms_sxd_company_info.ds is '企业所在市';
comment on column ${iol_schema}.icms_sxd_company_info.hzrq is '核准日期';
comment on column ${iol_schema}.icms_sxd_company_info.djzclxdm is '企业登记注册类型代码';
comment on column ${iol_schema}.icms_sxd_company_info.zcbzmc is '注册资本币种';
comment on column ${iol_schema}.icms_sxd_company_info.dmgyjdxz is '企业注册地街道地区码';
comment on column ${iol_schema}.icms_sxd_company_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_sxd_company_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_sxd_company_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_sxd_company_info.etl_timestamp is 'ETL处理时间戳';
