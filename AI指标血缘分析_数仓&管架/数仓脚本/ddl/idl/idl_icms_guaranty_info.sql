/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_guaranty_info
CreateDate: 20250527
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icms_guaranty_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icms_guaranty_info(
etl_dt date --数据日期
,guarantyid varchar2(32) --押品编号
,rwisenoughvalue varchar2(10) --现时是否足值(风险预警)
,ownertype varchar2(20) --所属人客户类型
,contracttype varchar2(2) --担保方式
,evaluatenetvalue number(24,6) --评估价值（元）
,guarantytype varchar2(32) --押品类型
,floorarea number(22,2) --不动产建筑面积(平方米)
,rwlocation varchar2(400) --地址/存放地点(风险预警)
,rwbuildbuyprice number(24,6) --建购价款(风险预警)
,evalorgname varchar2(200) --评估机构
,ownerid varchar2(16) --权利人客户编号
,realestatecode varchar2(900) --不动产证号
,guarantystatus varchar2(36) --担保状态
,updateorgid varchar2(200) --更新机构
,rwpledgerate number(24,6) --现时抵质押率(风险预警)
,guarantyname varchar2(200) --押品名称
,lettertype varchar2(6) --保函类型
,lettercontry varchar2(3) --证书开具国别
,evaldate date --估值日期
,ypguarantyid varchar2(40) --押品系统的编号
,migtflag varchar2(80) --迁移标志：crs rcr ilc upl
,letterno varchar2(40) --保函编号
,certid varchar2(40) --所属人证件号码
,confirmvalue number(24,6) --我行确认价值
,inputuserid varchar2(40) --登记人
,lettersum number(22,2) --保函金额
,guarantyrightid varchar2(300) --权证号码
,inputdate date --登记日期
,guarantyrighttype varchar2(20) --权证类型
,updatedate date --更新日期
,updateuserid varchar2(40) --更新人
,issueorgtype varchar2(4) --担保机构类型
,ownername varchar2(200) --权属人名称
,certtype varchar2(4) --所属人证件类型
,guaranteetype varchar2(5) --保证担保形式
,lettercurrency varchar2(18) --保函币种
,inputorgid varchar2(12) --登记机构
,rwpracticalvalue number(24,6) --现时实际价值(风险预警)
,guarantylocation varchar2(1000) --抵押物地址
,aboutotherid1 varchar2(80) --母账号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icms_guaranty_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_guaranty_info is '押品信息';
comment on column ${idl_schema}.icms_guaranty_info.etl_dt is '数据日期';
comment on column ${idl_schema}.icms_guaranty_info.guarantyid is '押品编号';
comment on column ${idl_schema}.icms_guaranty_info.rwisenoughvalue is '现时是否足值(风险预警)';
comment on column ${idl_schema}.icms_guaranty_info.ownertype is '所属人客户类型';
comment on column ${idl_schema}.icms_guaranty_info.contracttype is '担保方式';
comment on column ${idl_schema}.icms_guaranty_info.evaluatenetvalue is '评估价值（元）';
comment on column ${idl_schema}.icms_guaranty_info.guarantytype is '押品类型';
comment on column ${idl_schema}.icms_guaranty_info.floorarea is '不动产建筑面积(平方米)';
comment on column ${idl_schema}.icms_guaranty_info.rwlocation is '地址/存放地点(风险预警)';
comment on column ${idl_schema}.icms_guaranty_info.rwbuildbuyprice is '建购价款(风险预警)';
comment on column ${idl_schema}.icms_guaranty_info.evalorgname is '评估机构';
comment on column ${idl_schema}.icms_guaranty_info.ownerid is '权利人客户编号';
comment on column ${idl_schema}.icms_guaranty_info.realestatecode is '不动产证号';
comment on column ${idl_schema}.icms_guaranty_info.guarantystatus is '担保状态';
comment on column ${idl_schema}.icms_guaranty_info.updateorgid is '更新机构';
comment on column ${idl_schema}.icms_guaranty_info.rwpledgerate is '现时抵质押率(风险预警)';
comment on column ${idl_schema}.icms_guaranty_info.guarantyname is '押品名称';
comment on column ${idl_schema}.icms_guaranty_info.lettertype is '保函类型';
comment on column ${idl_schema}.icms_guaranty_info.lettercontry is '证书开具国别';
comment on column ${idl_schema}.icms_guaranty_info.evaldate is '估值日期';
comment on column ${idl_schema}.icms_guaranty_info.ypguarantyid is '押品系统的编号';
comment on column ${idl_schema}.icms_guaranty_info.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${idl_schema}.icms_guaranty_info.letterno is '保函编号';
comment on column ${idl_schema}.icms_guaranty_info.certid is '所属人证件号码';
comment on column ${idl_schema}.icms_guaranty_info.confirmvalue is '我行确认价值';
comment on column ${idl_schema}.icms_guaranty_info.inputuserid is '登记人';
comment on column ${idl_schema}.icms_guaranty_info.lettersum is '保函金额';
comment on column ${idl_schema}.icms_guaranty_info.guarantyrightid is '权证号码';
comment on column ${idl_schema}.icms_guaranty_info.inputdate is '登记日期';
comment on column ${idl_schema}.icms_guaranty_info.guarantyrighttype is '权证类型';
comment on column ${idl_schema}.icms_guaranty_info.updatedate is '更新日期';
comment on column ${idl_schema}.icms_guaranty_info.updateuserid is '更新人';
comment on column ${idl_schema}.icms_guaranty_info.issueorgtype is '担保机构类型';
comment on column ${idl_schema}.icms_guaranty_info.ownername is '权属人名称';
comment on column ${idl_schema}.icms_guaranty_info.certtype is '所属人证件类型';
comment on column ${idl_schema}.icms_guaranty_info.guaranteetype is '保证担保形式';
comment on column ${idl_schema}.icms_guaranty_info.lettercurrency is '保函币种';
comment on column ${idl_schema}.icms_guaranty_info.inputorgid is '登记机构';
comment on column ${idl_schema}.icms_guaranty_info.rwpracticalvalue is '现时实际价值(风险预警)';
comment on column ${idl_schema}.icms_guaranty_info.guarantylocation is '抵押物地址';
comment on column ${idl_schema}.icms_guaranty_info.aboutotherid1 is '母账号';

