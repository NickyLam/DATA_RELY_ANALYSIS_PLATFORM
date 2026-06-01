/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tmp_zjbk_inbaseinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tmp_zjbk_inbaseinfo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tmp_zjbk_inbaseinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tmp_zjbk_inbaseinfo(
    infrectype varchar2(3) -- 信息记录类型
    ,name varchar2(100) -- 姓名
    ,idtype varchar2(4) -- 证件类型
    ,idnum varchar2(20) -- 证件号码
    ,infsurccode varchar2(20) -- 信息来源编码
    ,rptdate varchar2(32) -- 信息报告日期
    ,rptdatecode varchar2(4) -- 报告时点说明代码
    ,cimoc varchar2(14) -- 客户资料维护机构代码
    ,customertype varchar2(4) -- 客户资料类型
    ,idsgmt_updflag varchar2(2) -- 其他标识信息段上报标志
    ,fcsinfsgmt_updflag varchar2(2) -- 基本概况信息段上报标志
    ,spsinfsgmt_updflag varchar2(2) -- 婚姻信息段上报标志
    ,eduinfsgmt_updflag varchar2(2) -- 教育信息段上报标志
    ,octpninfsgmt_updflag varchar2(2) -- 职业信息段上报标志
    ,redncinfsgmt_updflag varchar2(2) -- 居住地址信息段上报标志
    ,mlginfsgmt_updflag varchar2(2) -- 通讯地址信息段上报标志
    ,incinfsgmt_updflag varchar2(2) -- 收入信息段上报标志
    ,idnm varchar2(32) -- 其他标识个数
    ,idsgmtdata varchar2(2000) -- 其他标识段
    ,sex varchar2(2) -- 性别
    ,dob varchar2(32) -- 出生日期
    ,nation varchar2(6) -- 国籍
    ,houseadd varchar2(100) -- 户籍地址
    ,hhdist varchar2(6) -- 户籍所在地行政区划
    ,cellphone varchar2(11) -- 手机号码
    ,email varchar2(60) -- 电子邮箱
    ,fcsinfoupdate varchar2(32) -- 基本概况段信息更新日期
    ,maristatus varchar2(6) -- 婚姻状况
    ,sponame varchar2(30) -- 配偶姓名
    ,spoidtype varchar2(4) -- 配偶证件类型
    ,spoidnum varchar2(20) -- 配偶证件号码
    ,spotel varchar2(25) -- 配偶联系电话
    ,spscmpynm varchar2(80) -- 配偶工作单位
    ,spsinfoupdate varchar2(32) -- 婚姻信息段信息更新日期
    ,edulevel varchar2(4) -- 学历
    ,acadegree varchar2(4) -- 学位
    ,eduinfoupdate varchar2(32) -- 教育信息段信息更新日期
    ,empstatus varchar2(4) -- 就业状况
    ,cpnname varchar2(80) -- 单位名称
    ,cpntype varchar2(4) -- 单位性质
    ,industry varchar2(4) -- 单位所属行业
    ,cpnaddr varchar2(100) -- 单位详细地址
    ,cpnpc varchar2(6) -- 单位所在地邮编
    ,cpndist varchar2(6) -- 单位所在地行政区划
    ,cpntel varchar2(25) -- 单位电话
    ,occupation varchar2(4) -- 职业
    ,title varchar2(4) -- 职务
    ,techtitle varchar2(4) -- 职称
    ,workstartdate varchar2(4) -- 本单位工作起始年份
    ,octpninfoupdate varchar2(32) -- 职业信息段信息更新日期
    ,resistatus varchar2(4) -- 居住状况
    ,resiaddr varchar2(100) -- 居住地详细地址
    ,resipc varchar2(6) -- 居住地邮编
    ,residist varchar2(6) -- 居住地行政区划
    ,hometel varchar2(25) -- 住宅电话
    ,resiinfoupdate varchar2(32) -- 居住地址信息段信息更新日期
    ,mailaddr varchar2(100) -- 通讯地址
    ,mailpc varchar2(6) -- 通讯地邮编
    ,maildist varchar2(6) -- 通讯地行政区划
    ,mlginfoupdate varchar2(32) -- 通讯地址信息段信息更新日期
    ,annlinc varchar2(32) -- 自报年收入
    ,taxincome varchar2(32) -- 纳税年收入
    ,incinfoupdate varchar2(32) -- 收入信息段信息更新日期
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
grant select on ${iol_schema}.icms_tmp_zjbk_inbaseinfo to ${iml_schema};
grant select on ${iol_schema}.icms_tmp_zjbk_inbaseinfo to ${icl_schema};
grant select on ${iol_schema}.icms_tmp_zjbk_inbaseinfo to ${idl_schema};
grant select on ${iol_schema}.icms_tmp_zjbk_inbaseinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tmp_zjbk_inbaseinfo is '人行征信文件中间数据-个人基本信息记录表';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.infrectype is '信息记录类型';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.name is '姓名';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.idtype is '证件类型';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.idnum is '证件号码';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.infsurccode is '信息来源编码';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.rptdatecode is '报告时点说明代码';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.cimoc is '客户资料维护机构代码';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.customertype is '客户资料类型';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.idsgmt_updflag is '其他标识信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.fcsinfsgmt_updflag is '基本概况信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.spsinfsgmt_updflag is '婚姻信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.eduinfsgmt_updflag is '教育信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.octpninfsgmt_updflag is '职业信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.redncinfsgmt_updflag is '居住地址信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.mlginfsgmt_updflag is '通讯地址信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.incinfsgmt_updflag is '收入信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.idnm is '其他标识个数';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.idsgmtdata is '其他标识段';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.sex is '性别';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.dob is '出生日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.nation is '国籍';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.houseadd is '户籍地址';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.hhdist is '户籍所在地行政区划';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.cellphone is '手机号码';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.email is '电子邮箱';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.fcsinfoupdate is '基本概况段信息更新日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.maristatus is '婚姻状况';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.sponame is '配偶姓名';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.spoidtype is '配偶证件类型';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.spoidnum is '配偶证件号码';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.spotel is '配偶联系电话';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.spscmpynm is '配偶工作单位';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.spsinfoupdate is '婚姻信息段信息更新日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.edulevel is '学历';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.acadegree is '学位';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.eduinfoupdate is '教育信息段信息更新日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.empstatus is '就业状况';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.cpnname is '单位名称';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.cpntype is '单位性质';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.industry is '单位所属行业';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.cpnaddr is '单位详细地址';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.cpnpc is '单位所在地邮编';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.cpndist is '单位所在地行政区划';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.cpntel is '单位电话';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.occupation is '职业';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.title is '职务';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.techtitle is '职称';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.workstartdate is '本单位工作起始年份';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.octpninfoupdate is '职业信息段信息更新日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.resistatus is '居住状况';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.resiaddr is '居住地详细地址';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.resipc is '居住地邮编';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.residist is '居住地行政区划';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.hometel is '住宅电话';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.resiinfoupdate is '居住地址信息段信息更新日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.mailaddr is '通讯地址';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.mailpc is '通讯地邮编';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.maildist is '通讯地行政区划';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.mlginfoupdate is '通讯地址信息段信息更新日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.annlinc is '自报年收入';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.taxincome is '纳税年收入';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.incinfoupdate is '收入信息段信息更新日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inbaseinfo.etl_timestamp is 'ETL处理时间戳';
