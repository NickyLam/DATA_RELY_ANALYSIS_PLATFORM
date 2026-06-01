/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t09_corp_cust_supplement_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.eifs_t09_corp_cust_supplement_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t09_corp_cust_supplement_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t09_corp_cust_supplement_info_op purge;
drop table ${iol_schema}.eifs_t09_corp_cust_supplement_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t09_corp_cust_supplement_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t09_corp_cust_supplement_info where 0=1;

create table ${iol_schema}.eifs_t09_corp_cust_supplement_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t09_corp_cust_supplement_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t09_corp_cust_supplement_info_cl(
            custno -- 客户号
            ,lncdpw -- 贷款卡密码
            ,lncdtg -- 贷款卡状态
            ,lncddt -- 贷款卡年审日期
            ,lncdst -- 贷款卡年审结果
            ,lcditg -- 贷款卡吊销标志
            ,lcdidt -- 贷款卡吊销日期
            ,lcdrdt -- 贷款卡恢复日期
            ,upcrna -- 主管单位名称
            ,uprgcy -- 主管单位注册币种
            ,uprgam -- 主管单位注册金额
            ,upcrps -- 主管单位法定代表人
            ,upidtp -- 主管单位法定代表人证件类别
            ,upidno -- 主管单位法定代表人证件号
            ,upopno -- 主管单位基本户开户许可证号
            ,upcpcd -- 主管单位组织机构代码
            ,upcped -- 主管单位组织机构代码有效期
            ,retxtg -- 是否办理税务登记证
            ,txdpid -- 税务机关证明
            ,iscuim -- 是否国家重点企业
            ,ishtch -- 是否高新技术企业
            ,stckam -- 拥有我行股份数
            ,isgrup -- 是否集团公司
            ,gropid -- 集团客户id
            ,isgrmo -- 是否占用集团客户额度
            ,ctylev -- 行业类型(国标)
            ,waylv5 -- 行业类型(五级分类)
            ,etpcht -- 行业类型(信用评级)
            ,cuslv3 -- 事业法人规模或级别
            ,custp3 -- 事业法人客户类型
            ,lmtway -- 限制或鼓励行业
            ,rpmltp -- 财务报表类型
            ,retinm -- 离退休人数
            ,unvrnm -- 大专以上人数
            ,isdrec -- 有无董事会
            ,provce -- 所在省市
            ,inoutp -- 收支方式
            ,worang -- 职能范围
            ,supeor -- 上级主管部门
            ,buldmy -- 开办资金
            ,budgtp -- 预算形式
            ,orgown -- 机构隶属
            ,cdradt -- 与我行首次建立信贷关系日期
            ,prfd01 -- 预留字段
            ,prfd02 -- 预留字段2(组织机构类别细分)
            ,prfd03 -- 预留字段3(机构状态)
            ,prfd04 -- 预留字段
            ,prfd05 -- 预留字段
            ,salmon -- 销售额
            ,sizehy -- 企业规模行业
            ,isbank -- 是否是银监小企业
            ,banksz -- 银监小企业规模
            ,xwqyid -- 未知字段1（继承老cif）
            ,jjzzxs -- 经济组织形式
            ,jjbmlx -- 国民经济部门类型
            ,caccno -- 未知字段2（继承老cif）
            ,econtp -- 经济类型
            ,teleno -- 联系电话(征信)
            ,vocamx -- 行业代码明细(征信)
            ,psrntg -- 居民标示
            ,lwctna -- 法人代表
            ,lwidno -- 法人代表证件号码
            ,cptnnm -- 法人代表证明书编号
            ,vocatp -- 所属行业
            ,rgstad -- 地区代码
            ,regidt -- 注册日期
            ,regiad -- 注册地址
            ,operar -- 经营场地面积
            ,custlv -- 客户级别
            ,statlv -- 当前评级状态
            ,jonttg -- 联名客户标志
            ,doubtp -- 疑似客户类型
            ,tttrib -- 综合贡献度
            ,ttrema -- 客户总积分
            ,risklv -- 风险等级
            ,datatp -- 数据类型
            ,roletp -- 参与者类别
            ,isincu -- 是否系统内客户
            ,iscred -- 是否授信客户
            ,credid -- 信用评级id
            ,credln -- 授信额度
            ,bankno -- 银行行号
            ,banklv -- 行级别
            ,bktpid -- 行分类id
            ,jjdl -- 国民经济类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t09_corp_cust_supplement_info_op(
            custno -- 客户号
            ,lncdpw -- 贷款卡密码
            ,lncdtg -- 贷款卡状态
            ,lncddt -- 贷款卡年审日期
            ,lncdst -- 贷款卡年审结果
            ,lcditg -- 贷款卡吊销标志
            ,lcdidt -- 贷款卡吊销日期
            ,lcdrdt -- 贷款卡恢复日期
            ,upcrna -- 主管单位名称
            ,uprgcy -- 主管单位注册币种
            ,uprgam -- 主管单位注册金额
            ,upcrps -- 主管单位法定代表人
            ,upidtp -- 主管单位法定代表人证件类别
            ,upidno -- 主管单位法定代表人证件号
            ,upopno -- 主管单位基本户开户许可证号
            ,upcpcd -- 主管单位组织机构代码
            ,upcped -- 主管单位组织机构代码有效期
            ,retxtg -- 是否办理税务登记证
            ,txdpid -- 税务机关证明
            ,iscuim -- 是否国家重点企业
            ,ishtch -- 是否高新技术企业
            ,stckam -- 拥有我行股份数
            ,isgrup -- 是否集团公司
            ,gropid -- 集团客户id
            ,isgrmo -- 是否占用集团客户额度
            ,ctylev -- 行业类型(国标)
            ,waylv5 -- 行业类型(五级分类)
            ,etpcht -- 行业类型(信用评级)
            ,cuslv3 -- 事业法人规模或级别
            ,custp3 -- 事业法人客户类型
            ,lmtway -- 限制或鼓励行业
            ,rpmltp -- 财务报表类型
            ,retinm -- 离退休人数
            ,unvrnm -- 大专以上人数
            ,isdrec -- 有无董事会
            ,provce -- 所在省市
            ,inoutp -- 收支方式
            ,worang -- 职能范围
            ,supeor -- 上级主管部门
            ,buldmy -- 开办资金
            ,budgtp -- 预算形式
            ,orgown -- 机构隶属
            ,cdradt -- 与我行首次建立信贷关系日期
            ,prfd01 -- 预留字段
            ,prfd02 -- 预留字段2(组织机构类别细分)
            ,prfd03 -- 预留字段3(机构状态)
            ,prfd04 -- 预留字段
            ,prfd05 -- 预留字段
            ,salmon -- 销售额
            ,sizehy -- 企业规模行业
            ,isbank -- 是否是银监小企业
            ,banksz -- 银监小企业规模
            ,xwqyid -- 未知字段1（继承老cif）
            ,jjzzxs -- 经济组织形式
            ,jjbmlx -- 国民经济部门类型
            ,caccno -- 未知字段2（继承老cif）
            ,econtp -- 经济类型
            ,teleno -- 联系电话(征信)
            ,vocamx -- 行业代码明细(征信)
            ,psrntg -- 居民标示
            ,lwctna -- 法人代表
            ,lwidno -- 法人代表证件号码
            ,cptnnm -- 法人代表证明书编号
            ,vocatp -- 所属行业
            ,rgstad -- 地区代码
            ,regidt -- 注册日期
            ,regiad -- 注册地址
            ,operar -- 经营场地面积
            ,custlv -- 客户级别
            ,statlv -- 当前评级状态
            ,jonttg -- 联名客户标志
            ,doubtp -- 疑似客户类型
            ,tttrib -- 综合贡献度
            ,ttrema -- 客户总积分
            ,risklv -- 风险等级
            ,datatp -- 数据类型
            ,roletp -- 参与者类别
            ,isincu -- 是否系统内客户
            ,iscred -- 是否授信客户
            ,credid -- 信用评级id
            ,credln -- 授信额度
            ,bankno -- 银行行号
            ,banklv -- 行级别
            ,bktpid -- 行分类id
            ,jjdl -- 国民经济类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.custno, o.custno) as custno -- 客户号
    ,nvl(n.lncdpw, o.lncdpw) as lncdpw -- 贷款卡密码
    ,nvl(n.lncdtg, o.lncdtg) as lncdtg -- 贷款卡状态
    ,nvl(n.lncddt, o.lncddt) as lncddt -- 贷款卡年审日期
    ,nvl(n.lncdst, o.lncdst) as lncdst -- 贷款卡年审结果
    ,nvl(n.lcditg, o.lcditg) as lcditg -- 贷款卡吊销标志
    ,nvl(n.lcdidt, o.lcdidt) as lcdidt -- 贷款卡吊销日期
    ,nvl(n.lcdrdt, o.lcdrdt) as lcdrdt -- 贷款卡恢复日期
    ,nvl(n.upcrna, o.upcrna) as upcrna -- 主管单位名称
    ,nvl(n.uprgcy, o.uprgcy) as uprgcy -- 主管单位注册币种
    ,nvl(n.uprgam, o.uprgam) as uprgam -- 主管单位注册金额
    ,nvl(n.upcrps, o.upcrps) as upcrps -- 主管单位法定代表人
    ,nvl(n.upidtp, o.upidtp) as upidtp -- 主管单位法定代表人证件类别
    ,nvl(n.upidno, o.upidno) as upidno -- 主管单位法定代表人证件号
    ,nvl(n.upopno, o.upopno) as upopno -- 主管单位基本户开户许可证号
    ,nvl(n.upcpcd, o.upcpcd) as upcpcd -- 主管单位组织机构代码
    ,nvl(n.upcped, o.upcped) as upcped -- 主管单位组织机构代码有效期
    ,nvl(n.retxtg, o.retxtg) as retxtg -- 是否办理税务登记证
    ,nvl(n.txdpid, o.txdpid) as txdpid -- 税务机关证明
    ,nvl(n.iscuim, o.iscuim) as iscuim -- 是否国家重点企业
    ,nvl(n.ishtch, o.ishtch) as ishtch -- 是否高新技术企业
    ,nvl(n.stckam, o.stckam) as stckam -- 拥有我行股份数
    ,nvl(n.isgrup, o.isgrup) as isgrup -- 是否集团公司
    ,nvl(n.gropid, o.gropid) as gropid -- 集团客户id
    ,nvl(n.isgrmo, o.isgrmo) as isgrmo -- 是否占用集团客户额度
    ,nvl(n.ctylev, o.ctylev) as ctylev -- 行业类型(国标)
    ,nvl(n.waylv5, o.waylv5) as waylv5 -- 行业类型(五级分类)
    ,nvl(n.etpcht, o.etpcht) as etpcht -- 行业类型(信用评级)
    ,nvl(n.cuslv3, o.cuslv3) as cuslv3 -- 事业法人规模或级别
    ,nvl(n.custp3, o.custp3) as custp3 -- 事业法人客户类型
    ,nvl(n.lmtway, o.lmtway) as lmtway -- 限制或鼓励行业
    ,nvl(n.rpmltp, o.rpmltp) as rpmltp -- 财务报表类型
    ,nvl(n.retinm, o.retinm) as retinm -- 离退休人数
    ,nvl(n.unvrnm, o.unvrnm) as unvrnm -- 大专以上人数
    ,nvl(n.isdrec, o.isdrec) as isdrec -- 有无董事会
    ,nvl(n.provce, o.provce) as provce -- 所在省市
    ,nvl(n.inoutp, o.inoutp) as inoutp -- 收支方式
    ,nvl(n.worang, o.worang) as worang -- 职能范围
    ,nvl(n.supeor, o.supeor) as supeor -- 上级主管部门
    ,nvl(n.buldmy, o.buldmy) as buldmy -- 开办资金
    ,nvl(n.budgtp, o.budgtp) as budgtp -- 预算形式
    ,nvl(n.orgown, o.orgown) as orgown -- 机构隶属
    ,nvl(n.cdradt, o.cdradt) as cdradt -- 与我行首次建立信贷关系日期
    ,nvl(n.prfd01, o.prfd01) as prfd01 -- 预留字段
    ,nvl(n.prfd02, o.prfd02) as prfd02 -- 预留字段2(组织机构类别细分)
    ,nvl(n.prfd03, o.prfd03) as prfd03 -- 预留字段3(机构状态)
    ,nvl(n.prfd04, o.prfd04) as prfd04 -- 预留字段
    ,nvl(n.prfd05, o.prfd05) as prfd05 -- 预留字段
    ,nvl(n.salmon, o.salmon) as salmon -- 销售额
    ,nvl(n.sizehy, o.sizehy) as sizehy -- 企业规模行业
    ,nvl(n.isbank, o.isbank) as isbank -- 是否是银监小企业
    ,nvl(n.banksz, o.banksz) as banksz -- 银监小企业规模
    ,nvl(n.xwqyid, o.xwqyid) as xwqyid -- 未知字段1（继承老cif）
    ,nvl(n.jjzzxs, o.jjzzxs) as jjzzxs -- 经济组织形式
    ,nvl(n.jjbmlx, o.jjbmlx) as jjbmlx -- 国民经济部门类型
    ,nvl(n.caccno, o.caccno) as caccno -- 未知字段2（继承老cif）
    ,nvl(n.econtp, o.econtp) as econtp -- 经济类型
    ,nvl(n.teleno, o.teleno) as teleno -- 联系电话(征信)
    ,nvl(n.vocamx, o.vocamx) as vocamx -- 行业代码明细(征信)
    ,nvl(n.psrntg, o.psrntg) as psrntg -- 居民标示
    ,nvl(n.lwctna, o.lwctna) as lwctna -- 法人代表
    ,nvl(n.lwidno, o.lwidno) as lwidno -- 法人代表证件号码
    ,nvl(n.cptnnm, o.cptnnm) as cptnnm -- 法人代表证明书编号
    ,nvl(n.vocatp, o.vocatp) as vocatp -- 所属行业
    ,nvl(n.rgstad, o.rgstad) as rgstad -- 地区代码
    ,nvl(n.regidt, o.regidt) as regidt -- 注册日期
    ,nvl(n.regiad, o.regiad) as regiad -- 注册地址
    ,nvl(n.operar, o.operar) as operar -- 经营场地面积
    ,nvl(n.custlv, o.custlv) as custlv -- 客户级别
    ,nvl(n.statlv, o.statlv) as statlv -- 当前评级状态
    ,nvl(n.jonttg, o.jonttg) as jonttg -- 联名客户标志
    ,nvl(n.doubtp, o.doubtp) as doubtp -- 疑似客户类型
    ,nvl(n.tttrib, o.tttrib) as tttrib -- 综合贡献度
    ,nvl(n.ttrema, o.ttrema) as ttrema -- 客户总积分
    ,nvl(n.risklv, o.risklv) as risklv -- 风险等级
    ,nvl(n.datatp, o.datatp) as datatp -- 数据类型
    ,nvl(n.roletp, o.roletp) as roletp -- 参与者类别
    ,nvl(n.isincu, o.isincu) as isincu -- 是否系统内客户
    ,nvl(n.iscred, o.iscred) as iscred -- 是否授信客户
    ,nvl(n.credid, o.credid) as credid -- 信用评级id
    ,nvl(n.credln, o.credln) as credln -- 授信额度
    ,nvl(n.bankno, o.bankno) as bankno -- 银行行号
    ,nvl(n.banklv, o.banklv) as banklv -- 行级别
    ,nvl(n.bktpid, o.bktpid) as bktpid -- 行分类id
    ,nvl(n.jjdl, o.jjdl) as jjdl -- 国民经济类型
    ,case when
            n.custno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.custno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.custno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t09_corp_cust_supplement_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t09_corp_cust_supplement_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.custno = n.custno
where (
        o.custno is null
    )
    or (
        n.custno is null
    )
    or (
        o.lncdpw <> n.lncdpw
        or o.lncdtg <> n.lncdtg
        or o.lncddt <> n.lncddt
        or o.lncdst <> n.lncdst
        or o.lcditg <> n.lcditg
        or o.lcdidt <> n.lcdidt
        or o.lcdrdt <> n.lcdrdt
        or o.upcrna <> n.upcrna
        or o.uprgcy <> n.uprgcy
        or o.uprgam <> n.uprgam
        or o.upcrps <> n.upcrps
        or o.upidtp <> n.upidtp
        or o.upidno <> n.upidno
        or o.upopno <> n.upopno
        or o.upcpcd <> n.upcpcd
        or o.upcped <> n.upcped
        or o.retxtg <> n.retxtg
        or o.txdpid <> n.txdpid
        or o.iscuim <> n.iscuim
        or o.ishtch <> n.ishtch
        or o.stckam <> n.stckam
        or o.isgrup <> n.isgrup
        or o.gropid <> n.gropid
        or o.isgrmo <> n.isgrmo
        or o.ctylev <> n.ctylev
        or o.waylv5 <> n.waylv5
        or o.etpcht <> n.etpcht
        or o.cuslv3 <> n.cuslv3
        or o.custp3 <> n.custp3
        or o.lmtway <> n.lmtway
        or o.rpmltp <> n.rpmltp
        or o.retinm <> n.retinm
        or o.unvrnm <> n.unvrnm
        or o.isdrec <> n.isdrec
        or o.provce <> n.provce
        or o.inoutp <> n.inoutp
        or o.worang <> n.worang
        or o.supeor <> n.supeor
        or o.buldmy <> n.buldmy
        or o.budgtp <> n.budgtp
        or o.orgown <> n.orgown
        or o.cdradt <> n.cdradt
        or o.prfd01 <> n.prfd01
        or o.prfd02 <> n.prfd02
        or o.prfd03 <> n.prfd03
        or o.prfd04 <> n.prfd04
        or o.prfd05 <> n.prfd05
        or o.salmon <> n.salmon
        or o.sizehy <> n.sizehy
        or o.isbank <> n.isbank
        or o.banksz <> n.banksz
        or o.xwqyid <> n.xwqyid
        or o.jjzzxs <> n.jjzzxs
        or o.jjbmlx <> n.jjbmlx
        or o.caccno <> n.caccno
        or o.econtp <> n.econtp
        or o.teleno <> n.teleno
        or o.vocamx <> n.vocamx
        or o.psrntg <> n.psrntg
        or o.lwctna <> n.lwctna
        or o.lwidno <> n.lwidno
        or o.cptnnm <> n.cptnnm
        or o.vocatp <> n.vocatp
        or o.rgstad <> n.rgstad
        or o.regidt <> n.regidt
        or o.regiad <> n.regiad
        or o.operar <> n.operar
        or o.custlv <> n.custlv
        or o.statlv <> n.statlv
        or o.jonttg <> n.jonttg
        or o.doubtp <> n.doubtp
        or o.tttrib <> n.tttrib
        or o.ttrema <> n.ttrema
        or o.risklv <> n.risklv
        or o.datatp <> n.datatp
        or o.roletp <> n.roletp
        or o.isincu <> n.isincu
        or o.iscred <> n.iscred
        or o.credid <> n.credid
        or o.credln <> n.credln
        or o.bankno <> n.bankno
        or o.banklv <> n.banklv
        or o.bktpid <> n.bktpid
        or o.jjdl <> n.jjdl
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t09_corp_cust_supplement_info_cl(
            custno -- 客户号
            ,lncdpw -- 贷款卡密码
            ,lncdtg -- 贷款卡状态
            ,lncddt -- 贷款卡年审日期
            ,lncdst -- 贷款卡年审结果
            ,lcditg -- 贷款卡吊销标志
            ,lcdidt -- 贷款卡吊销日期
            ,lcdrdt -- 贷款卡恢复日期
            ,upcrna -- 主管单位名称
            ,uprgcy -- 主管单位注册币种
            ,uprgam -- 主管单位注册金额
            ,upcrps -- 主管单位法定代表人
            ,upidtp -- 主管单位法定代表人证件类别
            ,upidno -- 主管单位法定代表人证件号
            ,upopno -- 主管单位基本户开户许可证号
            ,upcpcd -- 主管单位组织机构代码
            ,upcped -- 主管单位组织机构代码有效期
            ,retxtg -- 是否办理税务登记证
            ,txdpid -- 税务机关证明
            ,iscuim -- 是否国家重点企业
            ,ishtch -- 是否高新技术企业
            ,stckam -- 拥有我行股份数
            ,isgrup -- 是否集团公司
            ,gropid -- 集团客户id
            ,isgrmo -- 是否占用集团客户额度
            ,ctylev -- 行业类型(国标)
            ,waylv5 -- 行业类型(五级分类)
            ,etpcht -- 行业类型(信用评级)
            ,cuslv3 -- 事业法人规模或级别
            ,custp3 -- 事业法人客户类型
            ,lmtway -- 限制或鼓励行业
            ,rpmltp -- 财务报表类型
            ,retinm -- 离退休人数
            ,unvrnm -- 大专以上人数
            ,isdrec -- 有无董事会
            ,provce -- 所在省市
            ,inoutp -- 收支方式
            ,worang -- 职能范围
            ,supeor -- 上级主管部门
            ,buldmy -- 开办资金
            ,budgtp -- 预算形式
            ,orgown -- 机构隶属
            ,cdradt -- 与我行首次建立信贷关系日期
            ,prfd01 -- 预留字段
            ,prfd02 -- 预留字段2(组织机构类别细分)
            ,prfd03 -- 预留字段3(机构状态)
            ,prfd04 -- 预留字段
            ,prfd05 -- 预留字段
            ,salmon -- 销售额
            ,sizehy -- 企业规模行业
            ,isbank -- 是否是银监小企业
            ,banksz -- 银监小企业规模
            ,xwqyid -- 未知字段1（继承老cif）
            ,jjzzxs -- 经济组织形式
            ,jjbmlx -- 国民经济部门类型
            ,caccno -- 未知字段2（继承老cif）
            ,econtp -- 经济类型
            ,teleno -- 联系电话(征信)
            ,vocamx -- 行业代码明细(征信)
            ,psrntg -- 居民标示
            ,lwctna -- 法人代表
            ,lwidno -- 法人代表证件号码
            ,cptnnm -- 法人代表证明书编号
            ,vocatp -- 所属行业
            ,rgstad -- 地区代码
            ,regidt -- 注册日期
            ,regiad -- 注册地址
            ,operar -- 经营场地面积
            ,custlv -- 客户级别
            ,statlv -- 当前评级状态
            ,jonttg -- 联名客户标志
            ,doubtp -- 疑似客户类型
            ,tttrib -- 综合贡献度
            ,ttrema -- 客户总积分
            ,risklv -- 风险等级
            ,datatp -- 数据类型
            ,roletp -- 参与者类别
            ,isincu -- 是否系统内客户
            ,iscred -- 是否授信客户
            ,credid -- 信用评级id
            ,credln -- 授信额度
            ,bankno -- 银行行号
            ,banklv -- 行级别
            ,bktpid -- 行分类id
            ,jjdl -- 国民经济类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t09_corp_cust_supplement_info_op(
            custno -- 客户号
            ,lncdpw -- 贷款卡密码
            ,lncdtg -- 贷款卡状态
            ,lncddt -- 贷款卡年审日期
            ,lncdst -- 贷款卡年审结果
            ,lcditg -- 贷款卡吊销标志
            ,lcdidt -- 贷款卡吊销日期
            ,lcdrdt -- 贷款卡恢复日期
            ,upcrna -- 主管单位名称
            ,uprgcy -- 主管单位注册币种
            ,uprgam -- 主管单位注册金额
            ,upcrps -- 主管单位法定代表人
            ,upidtp -- 主管单位法定代表人证件类别
            ,upidno -- 主管单位法定代表人证件号
            ,upopno -- 主管单位基本户开户许可证号
            ,upcpcd -- 主管单位组织机构代码
            ,upcped -- 主管单位组织机构代码有效期
            ,retxtg -- 是否办理税务登记证
            ,txdpid -- 税务机关证明
            ,iscuim -- 是否国家重点企业
            ,ishtch -- 是否高新技术企业
            ,stckam -- 拥有我行股份数
            ,isgrup -- 是否集团公司
            ,gropid -- 集团客户id
            ,isgrmo -- 是否占用集团客户额度
            ,ctylev -- 行业类型(国标)
            ,waylv5 -- 行业类型(五级分类)
            ,etpcht -- 行业类型(信用评级)
            ,cuslv3 -- 事业法人规模或级别
            ,custp3 -- 事业法人客户类型
            ,lmtway -- 限制或鼓励行业
            ,rpmltp -- 财务报表类型
            ,retinm -- 离退休人数
            ,unvrnm -- 大专以上人数
            ,isdrec -- 有无董事会
            ,provce -- 所在省市
            ,inoutp -- 收支方式
            ,worang -- 职能范围
            ,supeor -- 上级主管部门
            ,buldmy -- 开办资金
            ,budgtp -- 预算形式
            ,orgown -- 机构隶属
            ,cdradt -- 与我行首次建立信贷关系日期
            ,prfd01 -- 预留字段
            ,prfd02 -- 预留字段2(组织机构类别细分)
            ,prfd03 -- 预留字段3(机构状态)
            ,prfd04 -- 预留字段
            ,prfd05 -- 预留字段
            ,salmon -- 销售额
            ,sizehy -- 企业规模行业
            ,isbank -- 是否是银监小企业
            ,banksz -- 银监小企业规模
            ,xwqyid -- 未知字段1（继承老cif）
            ,jjzzxs -- 经济组织形式
            ,jjbmlx -- 国民经济部门类型
            ,caccno -- 未知字段2（继承老cif）
            ,econtp -- 经济类型
            ,teleno -- 联系电话(征信)
            ,vocamx -- 行业代码明细(征信)
            ,psrntg -- 居民标示
            ,lwctna -- 法人代表
            ,lwidno -- 法人代表证件号码
            ,cptnnm -- 法人代表证明书编号
            ,vocatp -- 所属行业
            ,rgstad -- 地区代码
            ,regidt -- 注册日期
            ,regiad -- 注册地址
            ,operar -- 经营场地面积
            ,custlv -- 客户级别
            ,statlv -- 当前评级状态
            ,jonttg -- 联名客户标志
            ,doubtp -- 疑似客户类型
            ,tttrib -- 综合贡献度
            ,ttrema -- 客户总积分
            ,risklv -- 风险等级
            ,datatp -- 数据类型
            ,roletp -- 参与者类别
            ,isincu -- 是否系统内客户
            ,iscred -- 是否授信客户
            ,credid -- 信用评级id
            ,credln -- 授信额度
            ,bankno -- 银行行号
            ,banklv -- 行级别
            ,bktpid -- 行分类id
            ,jjdl -- 国民经济类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.custno -- 客户号
    ,o.lncdpw -- 贷款卡密码
    ,o.lncdtg -- 贷款卡状态
    ,o.lncddt -- 贷款卡年审日期
    ,o.lncdst -- 贷款卡年审结果
    ,o.lcditg -- 贷款卡吊销标志
    ,o.lcdidt -- 贷款卡吊销日期
    ,o.lcdrdt -- 贷款卡恢复日期
    ,o.upcrna -- 主管单位名称
    ,o.uprgcy -- 主管单位注册币种
    ,o.uprgam -- 主管单位注册金额
    ,o.upcrps -- 主管单位法定代表人
    ,o.upidtp -- 主管单位法定代表人证件类别
    ,o.upidno -- 主管单位法定代表人证件号
    ,o.upopno -- 主管单位基本户开户许可证号
    ,o.upcpcd -- 主管单位组织机构代码
    ,o.upcped -- 主管单位组织机构代码有效期
    ,o.retxtg -- 是否办理税务登记证
    ,o.txdpid -- 税务机关证明
    ,o.iscuim -- 是否国家重点企业
    ,o.ishtch -- 是否高新技术企业
    ,o.stckam -- 拥有我行股份数
    ,o.isgrup -- 是否集团公司
    ,o.gropid -- 集团客户id
    ,o.isgrmo -- 是否占用集团客户额度
    ,o.ctylev -- 行业类型(国标)
    ,o.waylv5 -- 行业类型(五级分类)
    ,o.etpcht -- 行业类型(信用评级)
    ,o.cuslv3 -- 事业法人规模或级别
    ,o.custp3 -- 事业法人客户类型
    ,o.lmtway -- 限制或鼓励行业
    ,o.rpmltp -- 财务报表类型
    ,o.retinm -- 离退休人数
    ,o.unvrnm -- 大专以上人数
    ,o.isdrec -- 有无董事会
    ,o.provce -- 所在省市
    ,o.inoutp -- 收支方式
    ,o.worang -- 职能范围
    ,o.supeor -- 上级主管部门
    ,o.buldmy -- 开办资金
    ,o.budgtp -- 预算形式
    ,o.orgown -- 机构隶属
    ,o.cdradt -- 与我行首次建立信贷关系日期
    ,o.prfd01 -- 预留字段
    ,o.prfd02 -- 预留字段2(组织机构类别细分)
    ,o.prfd03 -- 预留字段3(机构状态)
    ,o.prfd04 -- 预留字段
    ,o.prfd05 -- 预留字段
    ,o.salmon -- 销售额
    ,o.sizehy -- 企业规模行业
    ,o.isbank -- 是否是银监小企业
    ,o.banksz -- 银监小企业规模
    ,o.xwqyid -- 未知字段1（继承老cif）
    ,o.jjzzxs -- 经济组织形式
    ,o.jjbmlx -- 国民经济部门类型
    ,o.caccno -- 未知字段2（继承老cif）
    ,o.econtp -- 经济类型
    ,o.teleno -- 联系电话(征信)
    ,o.vocamx -- 行业代码明细(征信)
    ,o.psrntg -- 居民标示
    ,o.lwctna -- 法人代表
    ,o.lwidno -- 法人代表证件号码
    ,o.cptnnm -- 法人代表证明书编号
    ,o.vocatp -- 所属行业
    ,o.rgstad -- 地区代码
    ,o.regidt -- 注册日期
    ,o.regiad -- 注册地址
    ,o.operar -- 经营场地面积
    ,o.custlv -- 客户级别
    ,o.statlv -- 当前评级状态
    ,o.jonttg -- 联名客户标志
    ,o.doubtp -- 疑似客户类型
    ,o.tttrib -- 综合贡献度
    ,o.ttrema -- 客户总积分
    ,o.risklv -- 风险等级
    ,o.datatp -- 数据类型
    ,o.roletp -- 参与者类别
    ,o.isincu -- 是否系统内客户
    ,o.iscred -- 是否授信客户
    ,o.credid -- 信用评级id
    ,o.credln -- 授信额度
    ,o.bankno -- 银行行号
    ,o.banklv -- 行级别
    ,o.bktpid -- 行分类id
    ,o.jjdl -- 国民经济类型
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.eifs_t09_corp_cust_supplement_info_bk o
    left join ${iol_schema}.eifs_t09_corp_cust_supplement_info_op n
        on
            o.custno = n.custno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t09_corp_cust_supplement_info_cl d
        on
            o.custno = d.custno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t09_corp_cust_supplement_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t09_corp_cust_supplement_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t09_corp_cust_supplement_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t09_corp_cust_supplement_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t09_corp_cust_supplement_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t09_corp_cust_supplement_info_cl;
alter table ${iol_schema}.eifs_t09_corp_cust_supplement_info exchange partition p_20991231 with table ${iol_schema}.eifs_t09_corp_cust_supplement_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t09_corp_cust_supplement_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t09_corp_cust_supplement_info_op purge;
drop table ${iol_schema}.eifs_t09_corp_cust_supplement_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t09_corp_cust_supplement_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t09_corp_cust_supplement_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
