/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_crss_guaranty_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.oass_crss_guaranty_info
whenever sqlerror continue none;
drop table ${idl_schema}.oass_crss_guaranty_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.oass_crss_guaranty_info(
    etl_dt date -- 数据日期
    ,guarantyid varchar2(40) -- 
    ,guarantytype varchar2(20) -- 
    ,guarantystatus varchar2(20) -- 
    ,ownerid varchar2(40) -- 
    ,ownername varchar2(80) -- 
    ,ownertype varchar2(20) -- 
    ,rate number(24,6) -- 
    ,custguarantytype varchar2(20) -- 
    ,subjectno varchar2(40) -- 
    ,relativeaccount varchar2(40) -- 
    ,guarantyrightid varchar2(200) -- 
    ,otherguarantyright varchar2(100) -- 
    ,guarantyname varchar2(80) -- 
    ,guarantysubtype varchar2(20) -- 
    ,guarantyownway varchar2(20) -- 
    ,guarantyusing varchar2(200) -- 
    ,guarantylocation varchar2(200) -- 
    ,guarantyamount number(24,6) -- 
    ,guarantyamount1 number(24,6) -- 
    ,guarantyamount2 number(24,6) -- 
    ,guarantyresouce varchar2(80) -- 
    ,guarantydate varchar2(80) -- 
    ,begindate varchar2(10) -- 
    ,ownertime varchar2(80) -- 
    ,guarantydescript varchar2(200) -- 
    ,aboutotherid1 varchar2(40) -- 
    ,aboutotherid2 varchar2(40) -- 
    ,aboutotherid3 varchar2(40) -- 
    ,aboutotherid4 varchar2(40) -- 
    ,purpose varchar2(200) -- 
    ,aboutsum1 number(24,6) -- 
    ,aboutsum2 number(24,6) -- 
    ,aboutrate number(24,6) -- 
    ,guarantyana varchar2(200) -- 
    ,guarantyprice number(24,6) -- 
    ,evalmethod varchar2(20) -- 
    ,evalorgid varchar2(40) -- 
    ,evalorgname varchar2(80) -- 
    ,evaldate varchar2(10) -- 
    ,evalnetvalue number(24,6) -- 
    ,confirmvalue number(24,6) -- 
    ,guarantyrate number(24,6) -- 
    ,thirdparty1 varchar2(200) -- 
    ,thirdparty2 varchar2(200) -- 
    ,thirdparty3 varchar2(200) -- 
    ,guarantydescribe1 varchar2(200) -- 
    ,guarantydescribe2 varchar2(200) -- 
    ,guarantydescribe3 varchar2(200) -- 
    ,flag1 varchar2(20) -- 
    ,flag2 varchar2(20) -- 
    ,flag3 varchar2(20) -- 
    ,flag4 varchar2(20) -- 
    ,guarantyregno varchar2(40) -- 
    ,guarantyregorg varchar2(80) -- 
    ,guarantyregdate varchar2(10) -- 
    ,guarantywodate varchar2(10) -- 
    ,insurecertno varchar2(40) -- 
    ,otherassumpsit varchar2(200) -- 
    ,inputorgid varchar2(40) -- 
    ,inputuserid varchar2(40) -- 
    ,inputdate varchar2(10) -- 
    ,updateuserid varchar2(40) -- 
    ,updatedate varchar2(10) -- 
    ,remark varchar2(4000) -- 
    ,sapvouchtype varchar2(20) -- 
    ,certtype varchar2(18) -- 
    ,certid varchar2(32) -- 
    ,loancardno varchar2(32) -- 
    ,guarantycurrency varchar2(18) -- 
    ,evalcurrency varchar2(18) -- 
    ,guarantydescribe4 number(24,6) -- 
    ,status varchar2(20) -- 
    ,eguarantyquality number(24,6) -- 
    ,eguarantyamount number(24,6) -- 
    ,eguarantyname varchar2(200) -- 
    ,eguarantyright varchar2(40) -- 
    ,eguarantyshare varchar2(40) -- 
    ,eguarantyowner varchar2(40) -- 
    ,eguarantyothersituation varchar2(200) -- 
    ,pledgename varchar2(80) -- 
    ,evaluatenetvalue number(24,6) -- 
    ,spareyear varchar2(10) -- 
    ,buytime varchar2(10) -- 
    ,buyprice number(24,6) -- 
    ,unitprice number(24,6) -- 
    ,guarantynumber number(24,6) -- 
    ,insurefirmname varchar2(40) -- 
    ,insuredate varchar2(10) -- 
    ,insuresum number(24,6) -- 
    ,insurecontent varchar2(100) -- 
    ,nowstate varchar2(4) -- 
    ,ifguarantyflag varchar2(2) -- 
    ,rwaguarantytype varchar2(3) -- 
    ,guarantypublishtype varchar2(80) -- 
    ,evaluatemeans varchar2(80) -- 
    ,ifsure varchar2(2) -- 
    ,islowrisk varchar2(10) -- 
    ,drawee varchar2(40) -- 
    ,ownerrelative varchar2(40) -- 
    ,enddate varchar2(10) -- 
    ,custodyability varchar2(40) -- 
    ,impawncustody varchar2(40) -- 
    ,mortgagepledgevalue number(24,6) -- 抵质押额
    ,jointowner varchar2(60) -- 
    ,flag5 varchar2(4) -- 
    ,commercebackdrop varchar2(32) -- 
    ,querycase varchar2(4) -- 
    ,chamberlain varchar2(32) -- 
    ,putoutorgid varchar2(32) -- 
    ,trandt varchar2(10) -- 质押止付交易日期
    ,transq varchar2(40) -- 质押止付流水号
    ,otherguarrigper varchar2(80) -- 
    ,ischange varchar2(2) -- 
    ,newhnmber varchar2(500) -- 
    ,newhaddress varchar2(500) -- 
    ,zqno varchar2(100) -- 
    ,guarantycompany varchar2(80) -- 
    ,commercialhousingcontract varchar2(100) -- 抵押权益的房产买卖合同编号
    ,chitnd varchar2(100) -- 
    ,carbrand varchar2(100) -- 
    ,cartype varchar2(100) -- 
    ,carnumber varchar2(100) -- 
    ,chariotnumber varchar2(100) -- 
    ,motornumber varchar2(100) -- 
    ,subguarantyrightid varchar2(40) -- 质押止付子户号
    ,recordlogno varchar2(40) -- 放款平台押品流水号
    ,updateflag varchar2(2) -- 修改标志
    ,inputoffice varchar2(100) -- 登记机关
    ,tempsaveflag varchar2(18) -- 保存标志（1 已保存）
    ,grteac varchar2(40) -- 保证金账户
    ,account varchar2(40) -- 银行账号
    ,fpflag varchar2(10) -- 理财产品解冻交易发起标志
    ,fpserialno varchar2(32) -- 理财产品冻结流水号
    ,swtbizid varchar2(32) -- 票据业务流水号
    ,isinuse varchar2(1) -- 添加维护标志1正常2不维护
    ,hbname1 varchar2(80) -- 核保人一姓名
    ,hbname2 varchar2(80) -- 核保人二姓名
    ,qzname varchar2(80) -- 权证名称
    ,bwstartdate varchar2(10) -- 表外核算开始日期
    ,djendtime varchar2(10) -- 登记有效终止日期
    ,hbdate varchar2(10) -- 核保日期
    ,qzendtime varchar2(10) -- 权证有效到期日期
    ,ifbwhs varchar2(1) -- 是否纳入表外核算
    ,approveno varchar2(18) -- 审批单号
    ,ypguarantytype varchar2(25) -- 
    ,ypguarantyid varchar2(40) -- 
    ,start_dt date -- 
    ,end_dt date -- 
    ,id_mark varchar2(10) -- 
    ,etl_timestamp timestamp -- 
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_crss_guaranty_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_crss_guaranty_info is '担保物信息表';
comment on column ${idl_schema}.oass_crss_guaranty_info.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyid is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantytype is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantystatus is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.ownerid is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.ownername is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.ownertype is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.rate is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.custguarantytype is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.subjectno is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.relativeaccount is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyrightid is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.otherguarantyright is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyname is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantysubtype is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyownway is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyusing is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantylocation is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyamount is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyamount1 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyamount2 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyresouce is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantydate is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.begindate is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.ownertime is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantydescript is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.aboutotherid1 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.aboutotherid2 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.aboutotherid3 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.aboutotherid4 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.purpose is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.aboutsum1 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.aboutsum2 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.aboutrate is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyana is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyprice is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.evalmethod is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.evalorgid is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.evalorgname is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.evaldate is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.evalnetvalue is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.confirmvalue is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyrate is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.thirdparty1 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.thirdparty2 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.thirdparty3 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantydescribe1 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantydescribe2 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantydescribe3 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.flag1 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.flag2 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.flag3 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.flag4 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyregno is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyregorg is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantyregdate is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantywodate is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.insurecertno is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.otherassumpsit is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.inputorgid is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.inputuserid is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.inputdate is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.updateuserid is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.updatedate is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.remark is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.sapvouchtype is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.certtype is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.certid is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.loancardno is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantycurrency is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.evalcurrency is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantydescribe4 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.status is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.eguarantyquality is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.eguarantyamount is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.eguarantyname is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.eguarantyright is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.eguarantyshare is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.eguarantyowner is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.eguarantyothersituation is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.pledgename is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.evaluatenetvalue is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.spareyear is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.buytime is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.buyprice is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.unitprice is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantynumber is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.insurefirmname is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.insuredate is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.insuresum is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.insurecontent is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.nowstate is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.ifguarantyflag is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.rwaguarantytype is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantypublishtype is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.evaluatemeans is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.ifsure is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.islowrisk is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.drawee is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.ownerrelative is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.enddate is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.custodyability is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.impawncustody is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.mortgagepledgevalue is '抵质押额';
comment on column ${idl_schema}.oass_crss_guaranty_info.jointowner is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.flag5 is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.commercebackdrop is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.querycase is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.chamberlain is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.putoutorgid is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.trandt is '质押止付交易日期';
comment on column ${idl_schema}.oass_crss_guaranty_info.transq is '质押止付流水号';
comment on column ${idl_schema}.oass_crss_guaranty_info.otherguarrigper is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.ischange is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.newhnmber is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.newhaddress is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.zqno is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.guarantycompany is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.commercialhousingcontract is '抵押权益的房产买卖合同编号';
comment on column ${idl_schema}.oass_crss_guaranty_info.chitnd is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.carbrand is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.cartype is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.carnumber is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.chariotnumber is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.motornumber is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.subguarantyrightid is '质押止付子户号';
comment on column ${idl_schema}.oass_crss_guaranty_info.recordlogno is '放款平台押品流水号';
comment on column ${idl_schema}.oass_crss_guaranty_info.updateflag is '修改标志';
comment on column ${idl_schema}.oass_crss_guaranty_info.inputoffice is '登记机关';
comment on column ${idl_schema}.oass_crss_guaranty_info.tempsaveflag is '保存标志（1 已保存）';
comment on column ${idl_schema}.oass_crss_guaranty_info.grteac is '保证金账户';
comment on column ${idl_schema}.oass_crss_guaranty_info.account is '银行账号';
comment on column ${idl_schema}.oass_crss_guaranty_info.fpflag is '理财产品解冻交易发起标志';
comment on column ${idl_schema}.oass_crss_guaranty_info.fpserialno is '理财产品冻结流水号';
comment on column ${idl_schema}.oass_crss_guaranty_info.swtbizid is '票据业务流水号';
comment on column ${idl_schema}.oass_crss_guaranty_info.isinuse is '添加维护标志1正常2不维护';
comment on column ${idl_schema}.oass_crss_guaranty_info.hbname1 is '核保人一姓名';
comment on column ${idl_schema}.oass_crss_guaranty_info.hbname2 is '核保人二姓名';
comment on column ${idl_schema}.oass_crss_guaranty_info.qzname is '权证名称';
comment on column ${idl_schema}.oass_crss_guaranty_info.bwstartdate is '表外核算开始日期';
comment on column ${idl_schema}.oass_crss_guaranty_info.djendtime is '登记有效终止日期';
comment on column ${idl_schema}.oass_crss_guaranty_info.hbdate is '核保日期';
comment on column ${idl_schema}.oass_crss_guaranty_info.qzendtime is '权证有效到期日期';
comment on column ${idl_schema}.oass_crss_guaranty_info.ifbwhs is '是否纳入表外核算';
comment on column ${idl_schema}.oass_crss_guaranty_info.approveno is '审批单号';
comment on column ${idl_schema}.oass_crss_guaranty_info.ypguarantytype is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.ypguarantyid is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.start_dt is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.end_dt is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.id_mark is '';
comment on column ${idl_schema}.oass_crss_guaranty_info.etl_timestamp is '';
