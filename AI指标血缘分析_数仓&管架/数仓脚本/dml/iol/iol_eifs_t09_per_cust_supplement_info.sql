/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t09_per_cust_supplement_info
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
create table ${iol_schema}.eifs_t09_per_cust_supplement_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t09_per_cust_supplement_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t09_per_cust_supplement_info_op purge;
drop table ${iol_schema}.eifs_t09_per_cust_supplement_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t09_per_cust_supplement_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t09_per_cust_supplement_info where 0=1;

create table ${iol_schema}.eifs_t09_per_cust_supplement_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t09_per_cust_supplement_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t09_per_cust_supplement_info_cl(
            custno -- 客户号
            ,custle -- 最近曾用英文名
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
            ,prsntp -- 开卡类型
            ,renatg -- 实名标识
            ,rgstad -- 地区代码
            ,sjcate -- 主体类型
            ,oralla -- 口语
            ,plvscd -- 政治面貌
            ,health -- 健康状况
            ,fvrttx -- 个人爱好
            ,chartg -- 个人品质
            ,credre -- 个人信用记录
            ,fmlynm -- 家庭总人数
            ,school -- 毕业院校
            ,insrid -- 社会保险号
            ,lncdno -- 贷款卡编号
            ,lncdpw -- 贷款卡密码
            ,lncdtg -- 贷款卡状态
            ,lncddt -- 贷款卡年审日期
            ,lncdst -- 贷款卡年审结果
            ,lcditg -- 贷款卡吊销标志
            ,lcdidt -- 贷款卡吊销日期
            ,lcdrdt -- 贷款卡恢复日期
            ,incmfy -- 家庭可支配年收入
            ,hmyrpy -- 家庭年支出
            ,gudian -- 监护人
            ,relatg -- 是否本行关系人
            ,remark -- 备注
            ,slrybk -- 工资帐号开户银行
            ,slryno -- 工资账号
            ,nwhock -- 现有负债
            ,workyr -- 当前单位任职年限
            ,workdt -- 本单位工作起始年份
            ,wkexis -- 是否有工作单位
            ,limacd -- 居住地址邮编
            ,homads -- 居住住址
            ,idadss -- 户籍地址
            ,hutype -- 本地户籍类型
            ,hmsupp -- 
            ,hmasse -- 
            ,identf -- 客户标识域
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t09_per_cust_supplement_info_op(
            custno -- 客户号
            ,custle -- 最近曾用英文名
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
            ,prsntp -- 开卡类型
            ,renatg -- 实名标识
            ,rgstad -- 地区代码
            ,sjcate -- 主体类型
            ,oralla -- 口语
            ,plvscd -- 政治面貌
            ,health -- 健康状况
            ,fvrttx -- 个人爱好
            ,chartg -- 个人品质
            ,credre -- 个人信用记录
            ,fmlynm -- 家庭总人数
            ,school -- 毕业院校
            ,insrid -- 社会保险号
            ,lncdno -- 贷款卡编号
            ,lncdpw -- 贷款卡密码
            ,lncdtg -- 贷款卡状态
            ,lncddt -- 贷款卡年审日期
            ,lncdst -- 贷款卡年审结果
            ,lcditg -- 贷款卡吊销标志
            ,lcdidt -- 贷款卡吊销日期
            ,lcdrdt -- 贷款卡恢复日期
            ,incmfy -- 家庭可支配年收入
            ,hmyrpy -- 家庭年支出
            ,gudian -- 监护人
            ,relatg -- 是否本行关系人
            ,remark -- 备注
            ,slrybk -- 工资帐号开户银行
            ,slryno -- 工资账号
            ,nwhock -- 现有负债
            ,workyr -- 当前单位任职年限
            ,workdt -- 本单位工作起始年份
            ,wkexis -- 是否有工作单位
            ,limacd -- 居住地址邮编
            ,homads -- 居住住址
            ,idadss -- 户籍地址
            ,hutype -- 本地户籍类型
            ,hmsupp -- 
            ,hmasse -- 
            ,identf -- 客户标识域
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.custno, o.custno) as custno -- 客户号
    ,nvl(n.custle, o.custle) as custle -- 最近曾用英文名
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
    ,nvl(n.prsntp, o.prsntp) as prsntp -- 开卡类型
    ,nvl(n.renatg, o.renatg) as renatg -- 实名标识
    ,nvl(n.rgstad, o.rgstad) as rgstad -- 地区代码
    ,nvl(n.sjcate, o.sjcate) as sjcate -- 主体类型
    ,nvl(n.oralla, o.oralla) as oralla -- 口语
    ,nvl(n.plvscd, o.plvscd) as plvscd -- 政治面貌
    ,nvl(n.health, o.health) as health -- 健康状况
    ,nvl(n.fvrttx, o.fvrttx) as fvrttx -- 个人爱好
    ,nvl(n.chartg, o.chartg) as chartg -- 个人品质
    ,nvl(n.credre, o.credre) as credre -- 个人信用记录
    ,nvl(n.fmlynm, o.fmlynm) as fmlynm -- 家庭总人数
    ,nvl(n.school, o.school) as school -- 毕业院校
    ,nvl(n.insrid, o.insrid) as insrid -- 社会保险号
    ,nvl(n.lncdno, o.lncdno) as lncdno -- 贷款卡编号
    ,nvl(n.lncdpw, o.lncdpw) as lncdpw -- 贷款卡密码
    ,nvl(n.lncdtg, o.lncdtg) as lncdtg -- 贷款卡状态
    ,nvl(n.lncddt, o.lncddt) as lncddt -- 贷款卡年审日期
    ,nvl(n.lncdst, o.lncdst) as lncdst -- 贷款卡年审结果
    ,nvl(n.lcditg, o.lcditg) as lcditg -- 贷款卡吊销标志
    ,nvl(n.lcdidt, o.lcdidt) as lcdidt -- 贷款卡吊销日期
    ,nvl(n.lcdrdt, o.lcdrdt) as lcdrdt -- 贷款卡恢复日期
    ,nvl(n.incmfy, o.incmfy) as incmfy -- 家庭可支配年收入
    ,nvl(n.hmyrpy, o.hmyrpy) as hmyrpy -- 家庭年支出
    ,nvl(n.gudian, o.gudian) as gudian -- 监护人
    ,nvl(n.relatg, o.relatg) as relatg -- 是否本行关系人
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.slrybk, o.slrybk) as slrybk -- 工资帐号开户银行
    ,nvl(n.slryno, o.slryno) as slryno -- 工资账号
    ,nvl(n.nwhock, o.nwhock) as nwhock -- 现有负债
    ,nvl(n.workyr, o.workyr) as workyr -- 当前单位任职年限
    ,nvl(n.workdt, o.workdt) as workdt -- 本单位工作起始年份
    ,nvl(n.wkexis, o.wkexis) as wkexis -- 是否有工作单位
    ,nvl(n.limacd, o.limacd) as limacd -- 居住地址邮编
    ,nvl(n.homads, o.homads) as homads -- 居住住址
    ,nvl(n.idadss, o.idadss) as idadss -- 户籍地址
    ,nvl(n.hutype, o.hutype) as hutype -- 本地户籍类型
    ,nvl(n.hmsupp, o.hmsupp) as hmsupp -- 
    ,nvl(n.hmasse, o.hmasse) as hmasse -- 
    ,nvl(n.identf, o.identf) as identf -- 客户标识域
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 
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
from (select * from ${iol_schema}.eifs_t09_per_cust_supplement_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t09_per_cust_supplement_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.custno = n.custno
where (
        o.custno is null
    )
    or (
        n.custno is null
    )
    or (
        o.custle <> n.custle
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
        or o.prsntp <> n.prsntp
        or o.renatg <> n.renatg
        or o.rgstad <> n.rgstad
        or o.sjcate <> n.sjcate
        or o.oralla <> n.oralla
        or o.plvscd <> n.plvscd
        or o.health <> n.health
        or o.fvrttx <> n.fvrttx
        or o.chartg <> n.chartg
        or o.credre <> n.credre
        or o.fmlynm <> n.fmlynm
        or o.school <> n.school
        or o.insrid <> n.insrid
        or o.lncdno <> n.lncdno
        or o.lncdpw <> n.lncdpw
        or o.lncdtg <> n.lncdtg
        or o.lncddt <> n.lncddt
        or o.lncdst <> n.lncdst
        or o.lcditg <> n.lcditg
        or o.lcdidt <> n.lcdidt
        or o.lcdrdt <> n.lcdrdt
        or o.incmfy <> n.incmfy
        or o.hmyrpy <> n.hmyrpy
        or o.gudian <> n.gudian
        or o.relatg <> n.relatg
        or o.remark <> n.remark
        or o.slrybk <> n.slrybk
        or o.slryno <> n.slryno
        or o.nwhock <> n.nwhock
        or o.workyr <> n.workyr
        or o.workdt <> n.workdt
        or o.wkexis <> n.wkexis
        or o.limacd <> n.limacd
        or o.homads <> n.homads
        or o.idadss <> n.idadss
        or o.hutype <> n.hutype
        or o.hmsupp <> n.hmsupp
        or o.hmasse <> n.hmasse
        or o.identf <> n.identf
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t09_per_cust_supplement_info_cl(
            custno -- 客户号
            ,custle -- 最近曾用英文名
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
            ,prsntp -- 开卡类型
            ,renatg -- 实名标识
            ,rgstad -- 地区代码
            ,sjcate -- 主体类型
            ,oralla -- 口语
            ,plvscd -- 政治面貌
            ,health -- 健康状况
            ,fvrttx -- 个人爱好
            ,chartg -- 个人品质
            ,credre -- 个人信用记录
            ,fmlynm -- 家庭总人数
            ,school -- 毕业院校
            ,insrid -- 社会保险号
            ,lncdno -- 贷款卡编号
            ,lncdpw -- 贷款卡密码
            ,lncdtg -- 贷款卡状态
            ,lncddt -- 贷款卡年审日期
            ,lncdst -- 贷款卡年审结果
            ,lcditg -- 贷款卡吊销标志
            ,lcdidt -- 贷款卡吊销日期
            ,lcdrdt -- 贷款卡恢复日期
            ,incmfy -- 家庭可支配年收入
            ,hmyrpy -- 家庭年支出
            ,gudian -- 监护人
            ,relatg -- 是否本行关系人
            ,remark -- 备注
            ,slrybk -- 工资帐号开户银行
            ,slryno -- 工资账号
            ,nwhock -- 现有负债
            ,workyr -- 当前单位任职年限
            ,workdt -- 本单位工作起始年份
            ,wkexis -- 是否有工作单位
            ,limacd -- 居住地址邮编
            ,homads -- 居住住址
            ,idadss -- 户籍地址
            ,hutype -- 本地户籍类型
            ,hmsupp -- 
            ,hmasse -- 
            ,identf -- 客户标识域
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t09_per_cust_supplement_info_op(
            custno -- 客户号
            ,custle -- 最近曾用英文名
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
            ,prsntp -- 开卡类型
            ,renatg -- 实名标识
            ,rgstad -- 地区代码
            ,sjcate -- 主体类型
            ,oralla -- 口语
            ,plvscd -- 政治面貌
            ,health -- 健康状况
            ,fvrttx -- 个人爱好
            ,chartg -- 个人品质
            ,credre -- 个人信用记录
            ,fmlynm -- 家庭总人数
            ,school -- 毕业院校
            ,insrid -- 社会保险号
            ,lncdno -- 贷款卡编号
            ,lncdpw -- 贷款卡密码
            ,lncdtg -- 贷款卡状态
            ,lncddt -- 贷款卡年审日期
            ,lncdst -- 贷款卡年审结果
            ,lcditg -- 贷款卡吊销标志
            ,lcdidt -- 贷款卡吊销日期
            ,lcdrdt -- 贷款卡恢复日期
            ,incmfy -- 家庭可支配年收入
            ,hmyrpy -- 家庭年支出
            ,gudian -- 监护人
            ,relatg -- 是否本行关系人
            ,remark -- 备注
            ,slrybk -- 工资帐号开户银行
            ,slryno -- 工资账号
            ,nwhock -- 现有负债
            ,workyr -- 当前单位任职年限
            ,workdt -- 本单位工作起始年份
            ,wkexis -- 是否有工作单位
            ,limacd -- 居住地址邮编
            ,homads -- 居住住址
            ,idadss -- 户籍地址
            ,hutype -- 本地户籍类型
            ,hmsupp -- 
            ,hmasse -- 
            ,identf -- 客户标识域
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.custno -- 客户号
    ,o.custle -- 最近曾用英文名
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
    ,o.prsntp -- 开卡类型
    ,o.renatg -- 实名标识
    ,o.rgstad -- 地区代码
    ,o.sjcate -- 主体类型
    ,o.oralla -- 口语
    ,o.plvscd -- 政治面貌
    ,o.health -- 健康状况
    ,o.fvrttx -- 个人爱好
    ,o.chartg -- 个人品质
    ,o.credre -- 个人信用记录
    ,o.fmlynm -- 家庭总人数
    ,o.school -- 毕业院校
    ,o.insrid -- 社会保险号
    ,o.lncdno -- 贷款卡编号
    ,o.lncdpw -- 贷款卡密码
    ,o.lncdtg -- 贷款卡状态
    ,o.lncddt -- 贷款卡年审日期
    ,o.lncdst -- 贷款卡年审结果
    ,o.lcditg -- 贷款卡吊销标志
    ,o.lcdidt -- 贷款卡吊销日期
    ,o.lcdrdt -- 贷款卡恢复日期
    ,o.incmfy -- 家庭可支配年收入
    ,o.hmyrpy -- 家庭年支出
    ,o.gudian -- 监护人
    ,o.relatg -- 是否本行关系人
    ,o.remark -- 备注
    ,o.slrybk -- 工资帐号开户银行
    ,o.slryno -- 工资账号
    ,o.nwhock -- 现有负债
    ,o.workyr -- 当前单位任职年限
    ,o.workdt -- 本单位工作起始年份
    ,o.wkexis -- 是否有工作单位
    ,o.limacd -- 居住地址邮编
    ,o.homads -- 居住住址
    ,o.idadss -- 户籍地址
    ,o.hutype -- 本地户籍类型
    ,o.hmsupp -- 
    ,o.hmasse -- 
    ,o.identf -- 客户标识域
    ,o.last_updated_stamp -- 
    ,o.last_updated_tx_stamp -- 
    ,o.created_stamp -- 
    ,o.created_tx_stamp -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.eifs_t09_per_cust_supplement_info_bk o
    left join ${iol_schema}.eifs_t09_per_cust_supplement_info_op n
        on
            o.custno = n.custno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t09_per_cust_supplement_info_cl d
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
-- truncate table ${iol_schema}.eifs_t09_per_cust_supplement_info;

-- 4.2 exchange partition
alter table ${iol_schema}.eifs_t09_per_cust_supplement_info exchange partition p_19000101 with table ${iol_schema}.eifs_t09_per_cust_supplement_info_cl;
alter table ${iol_schema}.eifs_t09_per_cust_supplement_info exchange partition p_20991231 with table ${iol_schema}.eifs_t09_per_cust_supplement_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t09_per_cust_supplement_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t09_per_cust_supplement_info_op purge;
drop table ${iol_schema}.eifs_t09_per_cust_supplement_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t09_per_cust_supplement_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t09_per_cust_supplement_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
