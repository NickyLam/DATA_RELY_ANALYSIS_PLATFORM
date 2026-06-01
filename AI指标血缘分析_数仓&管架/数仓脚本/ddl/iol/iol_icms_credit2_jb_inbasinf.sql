/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit2_jb_inbasinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit2_jb_inbasinf
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit2_jb_inbasinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit2_jb_inbasinf(
    incinfsgmt_updflag varchar2(2) -- 收入信息段标志
    ,resistatus varchar2(4) -- 居住状况
    ,resiaddr varchar2(100) -- 居住地详细地址
    ,mlginfoupdate varchar2(20) -- 通讯地址信息段信息更新日期
    ,idnm number(38) -- 其他标识个数
    ,email varchar2(60) -- 电子邮箱
    ,fcsinfoupdate varchar2(20) -- 基本概况段信息更新日期
    ,title varchar2(4) -- 职务
    ,resiinfoupdate varchar2(20) -- 居住地址信息段信息更新日期
    ,infrectype varchar2(3) -- 信息记录类型
    ,infsurccode varchar2(20) -- 信息来源编码
    ,customertype varchar2(4) -- 客户资料类型
    ,spscmpynm varchar2(80) -- 配偶工作单位
    ,cpndist varchar2(6) -- 单位所在地行政区划
    ,cpntel varchar2(25) -- 单位电话
    ,occupation varchar2(4) -- 职业
    ,mlginfsgmt_updflag varchar2(2) -- 通讯地址信息段标志
    ,idsgmtdata varchar2(2000) -- 其他标识段
    ,empstatus varchar2(4) -- 就业状况
    ,cpntype varchar2(4) -- 单位性质
    ,industry varchar2(4) -- 单位所属行业
    ,techtitle varchar2(4) -- 职称
    ,rptdatecode varchar2(4) -- 报告时点说明代码
    ,idsgmt_updflag varchar2(2) -- 其他标识信息段标志
    ,eduinfsgmt_updflag varchar2(2) -- 教育信息段标志
    ,octpninfsgmt_updflag varchar2(2) -- 职业信息段标志
    ,spoidtype varchar2(4) -- 配偶证件类型
    ,maildist varchar2(6) -- 通讯地行政区划
    ,dob varchar2(20) -- 出生日期
    ,houseadd varchar2(100) -- 户籍地址
    ,hhdist varchar2(6) -- 户籍所在地行政区划
    ,maristatus varchar2(6) -- 婚姻状况
    ,eduinfoupdate varchar2(20) -- 教育信息段信息更新日期
    ,incinfoupdate varchar2(20) -- 收入信息段信息更新日期
    ,spsinfsgmt_updflag varchar2(2) -- 婚姻信息段标志
    ,sponame varchar2(200) -- 配偶姓名
    ,mailaddr varchar2(100) -- 通讯地址
    ,edulevel varchar2(4) -- 学历
    ,cpnname varchar2(80) -- 单位名称
    ,idnum varchar2(20) -- 证件号码
    ,spsinfoupdate varchar2(20) -- 婚姻信息段信息更新日期
    ,octpninfoupdate varchar2(20) -- 职业信息段信息更新日期
    ,resipc varchar2(6) -- 居住地邮编
    ,annlinc varchar2(20) -- 自报年收入
    ,nation varchar2(6) -- 国籍
    ,cellphone varchar2(11) -- 手机号码
    ,sex varchar2(2) -- 性别
    ,spotel varchar2(25) -- 配偶联系电话
    ,idtype varchar2(4) -- 证件类型
    ,acadegree varchar2(4) -- 学位
    ,name varchar2(200) -- 姓名
    ,cimoc varchar2(14) -- 客户资料维护机构代码
    ,redncinfsgmt_updflag varchar2(2) -- 居住地址信息段标志
    ,spoidnum varchar2(20) -- 配偶证件号码
    ,cpnpc varchar2(6) -- 单位所在地邮编
    ,workstartdate varchar2(4) -- 本单位工作起始年份
    ,residist varchar2(6) -- 居住地行政区划
    ,create_time varchar2(20) -- 入库时间
    ,rptdate varchar2(20) -- 信息报告日期
    ,fcsinfsgmt_updflag varchar2(2) -- 基本概况信息段上报标志
    ,cpnaddr varchar2(100) -- 单位详细地址
    ,hometel varchar2(25) -- 住宅电话
    ,mailpc varchar2(6) -- 通讯地邮编
    ,taxincome varchar2(20) -- 纳税年收入
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
grant select on ${iol_schema}.icms_credit2_jb_inbasinf to ${iml_schema};
grant select on ${iol_schema}.icms_credit2_jb_inbasinf to ${icl_schema};
grant select on ${iol_schema}.icms_credit2_jb_inbasinf to ${idl_schema};
grant select on ${iol_schema}.icms_credit2_jb_inbasinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit2_jb_inbasinf is '人民银行个人征信元数据：个人基本信息记录';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.incinfsgmt_updflag is '收入信息段标志';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.resistatus is '居住状况';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.resiaddr is '居住地详细地址';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.mlginfoupdate is '通讯地址信息段信息更新日期';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.idnm is '其他标识个数';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.email is '电子邮箱';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.fcsinfoupdate is '基本概况段信息更新日期';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.title is '职务';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.resiinfoupdate is '居住地址信息段信息更新日期';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.infrectype is '信息记录类型';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.infsurccode is '信息来源编码';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.customertype is '客户资料类型';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.spscmpynm is '配偶工作单位';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.cpndist is '单位所在地行政区划';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.cpntel is '单位电话';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.occupation is '职业';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.mlginfsgmt_updflag is '通讯地址信息段标志';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.idsgmtdata is '其他标识段';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.empstatus is '就业状况';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.cpntype is '单位性质';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.industry is '单位所属行业';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.techtitle is '职称';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.rptdatecode is '报告时点说明代码';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.idsgmt_updflag is '其他标识信息段标志';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.eduinfsgmt_updflag is '教育信息段标志';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.octpninfsgmt_updflag is '职业信息段标志';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.spoidtype is '配偶证件类型';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.maildist is '通讯地行政区划';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.dob is '出生日期';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.houseadd is '户籍地址';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.hhdist is '户籍所在地行政区划';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.maristatus is '婚姻状况';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.eduinfoupdate is '教育信息段信息更新日期';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.incinfoupdate is '收入信息段信息更新日期';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.spsinfsgmt_updflag is '婚姻信息段标志';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.sponame is '配偶姓名';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.mailaddr is '通讯地址';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.edulevel is '学历';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.cpnname is '单位名称';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.idnum is '证件号码';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.spsinfoupdate is '婚姻信息段信息更新日期';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.octpninfoupdate is '职业信息段信息更新日期';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.resipc is '居住地邮编';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.annlinc is '自报年收入';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.nation is '国籍';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.cellphone is '手机号码';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.sex is '性别';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.spotel is '配偶联系电话';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.idtype is '证件类型';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.acadegree is '学位';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.name is '姓名';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.cimoc is '客户资料维护机构代码';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.redncinfsgmt_updflag is '居住地址信息段标志';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.spoidnum is '配偶证件号码';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.cpnpc is '单位所在地邮编';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.workstartdate is '本单位工作起始年份';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.residist is '居住地行政区划';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.fcsinfsgmt_updflag is '基本概况信息段上报标志';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.cpnaddr is '单位详细地址';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.hometel is '住宅电话';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.mailpc is '通讯地邮编';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.taxincome is '纳税年收入';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit2_jb_inbasinf.etl_timestamp is 'ETL处理时间戳';
