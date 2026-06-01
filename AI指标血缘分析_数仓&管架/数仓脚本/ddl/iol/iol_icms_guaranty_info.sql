/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_guaranty_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_guaranty_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_guaranty_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_guaranty_info(
    guarantyid varchar2(32) -- 押品编号
    ,rwisenoughvalue varchar2(10) -- 现时是否足值(风险预警)
    ,ownertype varchar2(20) -- 所属人客户类型
    ,contracttype varchar2(2) -- 担保方式
    ,evaluatenetvalue number(24,6) -- 评估价值（元）
    ,guarantytype varchar2(32) -- 押品类型
    ,floorarea number(22,2) -- 不动产建筑面积(平方米)
    ,rwlocation varchar2(400) -- 地址/存放地点(风险预警)
    ,rwbuildbuyprice number(24,6) -- 建购价款(风险预警)
    ,evalorgname varchar2(200) -- 评估机构
    ,ownerid varchar2(16) -- 权利人客户编号
    ,realestatecode varchar2(900) -- 不动产证号
    ,guarantystatus varchar2(36) -- 担保状态
    ,updateorgid varchar2(200) -- 更新机构
    ,rwpledgerate number(24,6) -- 现时抵质押率(风险预警)
    ,guarantyname varchar2(200) -- 押品名称
    ,lettertype varchar2(6) -- 保函类型
    ,lettercontry varchar2(3) -- 证书开具国别
    ,evaldate date -- 估值日期
    ,ypguarantyid varchar2(40) -- 押品系统的编号
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,letterno varchar2(40) -- 保函编号
    ,certid varchar2(40) -- 所属人证件号码
    ,confirmvalue number(24,6) -- 我行确认价值
    ,inputuserid varchar2(40) -- 登记人
    ,lettersum number(22,2) -- 保函金额
    ,guarantyrightid varchar2(300) -- 权证号码
    ,inputdate date -- 登记日期
    ,guarantyrighttype varchar2(20) -- 权证类型
    ,updatedate date -- 更新日期
    ,updateuserid varchar2(40) -- 更新人
    ,issueorgtype varchar2(4) -- 担保机构类型
    ,ownername varchar2(200) -- 权属人名称
    ,certtype varchar2(4) -- 所属人证件类型
    ,guaranteetype varchar2(5) -- 保证担保形式
    ,lettercurrency varchar2(18) -- 保函币种
    ,inputorgid varchar2(12) -- 登记机构
    ,rwpracticalvalue number(24,6) -- 现时实际价值(风险预警)
    ,guarantylocation varchar2(1000) -- 抵押物地址
    ,aboutotherid1 varchar2(80) -- 母账号
    ,aboutotherid2 varchar2(40) -- 
    ,aboutotherid3 varchar2(40) -- 
    ,financialyield number(12,8) -- 
    ,collateraltype varchar2(16) -- 
    ,stockcode varchar2(30) -- 
    ,stockname varchar2(100) -- 
    ,shareamount number(32,0) -- 
    ,persharemarketprice number(24,6) -- 
    ,totalvalue number(24,6) -- 
    ,warningline number(24,6) -- 
    ,liquidateline number(24,6) -- 
    ,evalexpiredate date -- 
    ,registerno varchar2(200) -- 
    ,statuschangetime date -- 
    ,isnewshilianassessvalue varchar2(1) -- 
    ,newshilianassessvalue varchar2(10) -- 
    ,newshilianassessdate date -- 
    ,isshilianaccevaluate varchar2(1) -- 
    ,isourbankaccevaluate varchar2(1) -- 
    ,externalevaluatevalue number(24,6) -- 
    ,externalevaluatedate date -- 
    ,externalevaluateexpiredate date -- 
    ,remark varchar2(4000) -- 备注
    ,registcountry varchar2(225) -- 保证人注册地所在国家或地区
    ,registcountryresult varchar2(225) -- 保证人注册地所在国家或地区外部评级结果
    ,outratingdate varchar2(40) -- 保证人外部评级日期
    ,outratingresult varchar2(225) -- 保证人外部评级结果
    ,inratingdate varchar2(225) -- 保证人内部评级日期
    ,inratingresult varchar2(225) -- 保证人内部评级结果
    ,guarcash number(24,6) -- 担保公司保证金金额
    ,isstage varchar2(6) -- 是否阶段性担保
    ,insuranceno varchar2(135) -- 保证保险保单号码
    ,purpose varchar2(6) -- 保证目的
    ,independence varchar2(6) -- 保证人担保独立性
    ,isresident varchar2(6) -- 是否居民
    ,netassetcurrency varchar2(18) -- 净资产币种
    ,orgname varchar2(225) -- 开立机构名称（保函）\开证机构名称（信用证）
    ,orgtype varchar2(6) -- 开立机构类型（保函）\开证机构类型（信用证）
    ,iscancel varchar2(6) -- 是否不可撤销
    ,vouchertype varchar2(6) -- 保证人所有制类型
    ,netasset number(24,6) -- 保证人净资产
    ,confirmcurrency varchar2(18) -- 担保币种
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
grant select on ${iol_schema}.icms_guaranty_info to ${iml_schema};
grant select on ${iol_schema}.icms_guaranty_info to ${icl_schema};
grant select on ${iol_schema}.icms_guaranty_info to ${idl_schema};
grant select on ${iol_schema}.icms_guaranty_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_guaranty_info is '';
comment on column ${iol_schema}.icms_guaranty_info.guarantyid is '押品编号';
comment on column ${iol_schema}.icms_guaranty_info.rwisenoughvalue is '现时是否足值(风险预警)';
comment on column ${iol_schema}.icms_guaranty_info.ownertype is '所属人客户类型';
comment on column ${iol_schema}.icms_guaranty_info.contracttype is '担保方式';
comment on column ${iol_schema}.icms_guaranty_info.evaluatenetvalue is '评估价值（元）';
comment on column ${iol_schema}.icms_guaranty_info.guarantytype is '押品类型';
comment on column ${iol_schema}.icms_guaranty_info.floorarea is '不动产建筑面积(平方米)';
comment on column ${iol_schema}.icms_guaranty_info.rwlocation is '地址/存放地点(风险预警)';
comment on column ${iol_schema}.icms_guaranty_info.rwbuildbuyprice is '建购价款(风险预警)';
comment on column ${iol_schema}.icms_guaranty_info.evalorgname is '评估机构';
comment on column ${iol_schema}.icms_guaranty_info.ownerid is '权利人客户编号';
comment on column ${iol_schema}.icms_guaranty_info.realestatecode is '不动产证号';
comment on column ${iol_schema}.icms_guaranty_info.guarantystatus is '担保状态';
comment on column ${iol_schema}.icms_guaranty_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_guaranty_info.rwpledgerate is '现时抵质押率(风险预警)';
comment on column ${iol_schema}.icms_guaranty_info.guarantyname is '押品名称';
comment on column ${iol_schema}.icms_guaranty_info.lettertype is '保函类型';
comment on column ${iol_schema}.icms_guaranty_info.lettercontry is '证书开具国别';
comment on column ${iol_schema}.icms_guaranty_info.evaldate is '估值日期';
comment on column ${iol_schema}.icms_guaranty_info.ypguarantyid is '押品系统的编号';
comment on column ${iol_schema}.icms_guaranty_info.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_guaranty_info.letterno is '保函编号';
comment on column ${iol_schema}.icms_guaranty_info.certid is '所属人证件号码';
comment on column ${iol_schema}.icms_guaranty_info.confirmvalue is '我行确认价值';
comment on column ${iol_schema}.icms_guaranty_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_guaranty_info.lettersum is '保函金额';
comment on column ${iol_schema}.icms_guaranty_info.guarantyrightid is '权证号码';
comment on column ${iol_schema}.icms_guaranty_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_guaranty_info.guarantyrighttype is '权证类型';
comment on column ${iol_schema}.icms_guaranty_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_guaranty_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_guaranty_info.issueorgtype is '担保机构类型';
comment on column ${iol_schema}.icms_guaranty_info.ownername is '权属人名称';
comment on column ${iol_schema}.icms_guaranty_info.certtype is '所属人证件类型';
comment on column ${iol_schema}.icms_guaranty_info.guaranteetype is '保证担保形式';
comment on column ${iol_schema}.icms_guaranty_info.lettercurrency is '保函币种';
comment on column ${iol_schema}.icms_guaranty_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_guaranty_info.rwpracticalvalue is '现时实际价值(风险预警)';
comment on column ${iol_schema}.icms_guaranty_info.guarantylocation is '抵押物地址';
comment on column ${iol_schema}.icms_guaranty_info.aboutotherid1 is '母账号';
comment on column ${iol_schema}.icms_guaranty_info.aboutotherid2 is '';
comment on column ${iol_schema}.icms_guaranty_info.aboutotherid3 is '';
comment on column ${iol_schema}.icms_guaranty_info.financialyield is '';
comment on column ${iol_schema}.icms_guaranty_info.collateraltype is '';
comment on column ${iol_schema}.icms_guaranty_info.stockcode is '';
comment on column ${iol_schema}.icms_guaranty_info.stockname is '';
comment on column ${iol_schema}.icms_guaranty_info.shareamount is '';
comment on column ${iol_schema}.icms_guaranty_info.persharemarketprice is '';
comment on column ${iol_schema}.icms_guaranty_info.totalvalue is '';
comment on column ${iol_schema}.icms_guaranty_info.warningline is '';
comment on column ${iol_schema}.icms_guaranty_info.liquidateline is '';
comment on column ${iol_schema}.icms_guaranty_info.evalexpiredate is '';
comment on column ${iol_schema}.icms_guaranty_info.registerno is '';
comment on column ${iol_schema}.icms_guaranty_info.statuschangetime is '';
comment on column ${iol_schema}.icms_guaranty_info.isnewshilianassessvalue is '';
comment on column ${iol_schema}.icms_guaranty_info.newshilianassessvalue is '';
comment on column ${iol_schema}.icms_guaranty_info.newshilianassessdate is '';
comment on column ${iol_schema}.icms_guaranty_info.isshilianaccevaluate is '';
comment on column ${iol_schema}.icms_guaranty_info.isourbankaccevaluate is '';
comment on column ${iol_schema}.icms_guaranty_info.externalevaluatevalue is '';
comment on column ${iol_schema}.icms_guaranty_info.externalevaluatedate is '';
comment on column ${iol_schema}.icms_guaranty_info.externalevaluateexpiredate is '';
comment on column ${iol_schema}.icms_guaranty_info.remark is '备注';
comment on column ${iol_schema}.icms_guaranty_info.registcountry is '保证人注册地所在国家或地区';
comment on column ${iol_schema}.icms_guaranty_info.registcountryresult is '保证人注册地所在国家或地区外部评级结果';
comment on column ${iol_schema}.icms_guaranty_info.outratingdate is '保证人外部评级日期';
comment on column ${iol_schema}.icms_guaranty_info.outratingresult is '保证人外部评级结果';
comment on column ${iol_schema}.icms_guaranty_info.inratingdate is '保证人内部评级日期';
comment on column ${iol_schema}.icms_guaranty_info.inratingresult is '保证人内部评级结果';
comment on column ${iol_schema}.icms_guaranty_info.guarcash is '担保公司保证金金额';
comment on column ${iol_schema}.icms_guaranty_info.isstage is '是否阶段性担保';
comment on column ${iol_schema}.icms_guaranty_info.insuranceno is '保证保险保单号码';
comment on column ${iol_schema}.icms_guaranty_info.purpose is '保证目的';
comment on column ${iol_schema}.icms_guaranty_info.independence is '保证人担保独立性';
comment on column ${iol_schema}.icms_guaranty_info.isresident is '是否居民';
comment on column ${iol_schema}.icms_guaranty_info.netassetcurrency is '净资产币种';
comment on column ${iol_schema}.icms_guaranty_info.orgname is '开立机构名称（保函）\开证机构名称（信用证）';
comment on column ${iol_schema}.icms_guaranty_info.orgtype is '开立机构类型（保函）\开证机构类型（信用证）';
comment on column ${iol_schema}.icms_guaranty_info.iscancel is '是否不可撤销';
comment on column ${iol_schema}.icms_guaranty_info.vouchertype is '保证人所有制类型';
comment on column ${iol_schema}.icms_guaranty_info.netasset is '保证人净资产';
comment on column ${iol_schema}.icms_guaranty_info.confirmcurrency is '担保币种';
comment on column ${iol_schema}.icms_guaranty_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_guaranty_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_guaranty_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_guaranty_info.etl_timestamp is 'ETL处理时间戳';
