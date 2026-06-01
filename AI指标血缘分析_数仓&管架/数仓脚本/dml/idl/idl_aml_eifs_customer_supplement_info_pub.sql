/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_eifs_customer_supplement_info_pub
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_eifs_customer_supplement_info_pub drop partition p_${last_date};
alter table ${idl_schema}.aml_eifs_customer_supplement_info_pub drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_eifs_customer_supplement_info_pub add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_eifs_customer_supplement_info_pub partition for (to_date('${batch_date}','yyyymmdd')) (
    custno  -- CIF客户号
    ,lncdpw  -- 贷款卡密码
    ,lncdtg  -- 贷款卡状态
    ,lncddt  -- 贷款卡年审日期
    ,lncdst  -- 贷款卡年审结果
    ,lcditg  -- 贷款卡吊销标志
    ,lcdidt  -- 贷款卡吊销日期
    ,lcdrdt  -- 贷款卡恢复日期
    ,upcrna  -- 主管单位名称
    ,uprgcy  -- 主管单位注册币种
    ,uprgam  -- 主管单位注册金额
    ,upcrps  -- 主管单位法定代表人
    ,upidtp  -- 主管单位法定代表人证件类别
    ,upidno  -- 主管单位法定代表人证件号
    ,upopno  -- 主管单位基本户开户许可证号
    ,upcpcd  -- 主管单位组织机构代码
    ,upcped  -- 主管单位组织机构代码有效期
    ,retxtg  -- 是否办理税务登记证
    ,txdpid  -- 税务机关证明
    ,iscuim  -- 是否国家重点企业
    ,ishtch  -- 是否高新技术企业
    ,stckam  -- 拥有我行股份数
    ,isgrup  -- 是否集团公司
    ,gropid  -- 集团客户id
    ,isgrmo  -- 是否占用集团客户额度
    ,ctylev  -- 行业类型(国标)
    ,waylv5  -- 行业类型(五级分类)
    ,etpcht  -- 行业类型(信用评级)
    ,cuslv3  -- 事业法人规模或级别
    ,custp3  -- 事业法人客户类型
    ,lmtway  -- 限制或鼓励行业
    ,rpmltp  -- 财务报表类型
    ,retinm  -- 离退休人数
    ,unvrnm  -- 大专以上人数
    ,isdrec  -- 有无董事会
    ,provce  -- 所在省市
    ,inoutp  -- 收支方式
    ,worang  -- 职能范围
    ,supeor  -- 上级主管部门
    ,buldmy  -- 开办资金
    ,budgtp  -- 预算形式
    ,orgown  -- 机构隶属
    ,cdradt  -- 与我行首次建立信贷关系日期
    ,prfd01  -- 预留字段
    ,prfd02  -- 预留字段2(组织机构类别细分)
    ,prfd03  -- 预留字段3(机构状态)
    ,prfd04  -- 预留字段
    ,prfd05  -- 预留字段
    ,salmon  -- 销售额
    ,sizehy  -- 企业规模行业
    ,isbank  -- 是否是银监小企业
    ,banksz  -- 银监小企业规模
    ,xwqyid  -- 未知字段1（继承老cif）
    ,jjzzxs  -- 经济组织形式
    ,jjbmlx  -- 国民经济部门类型
    ,caccno  -- 未知字段2（继承老cif）
    ,econtp  -- 经济类型
    ,teleno  -- 联系电话(征信)
    ,vocamx  -- 行业代码明细(征信)
    ,psrntg  -- 居民标示
    ,lwctna  -- 法人代表
    ,lwidno  -- 法人代表证件号码
    ,cptnnm  -- 法人代表证明书编号
    ,vocatp  -- 所属行业
    ,rgstad  -- 地区代码
    ,regidt  -- 注册日期
    ,regiad  -- 注册地址
    ,operar  -- 经营场地面积
    ,custlv  -- 客户级别
    ,statlv  -- 当前评级状态
    ,jonttg  -- 联名客户标志
    ,doubtp  -- 疑似客户类型
    ,tttrib  -- 综合贡献度
    ,ttrema  -- 客户总积分
    ,risklv  -- 风险等级
    ,datatp  -- 数据类型
    ,roletp  -- 参与者类别
    ,isincu  -- 是否系统内客户
    ,iscred  -- 是否授信客户
    ,credid  -- 信用评级ID
    ,credln  -- 授信额度
    ,last_updated_stamp  -- 最后更新时间
    ,last_updated_tx_stamp  -- 最后更新事务时间
    ,created_stamp  -- 创建时间
    ,created_tx_stamp  -- 创建事务时间
    ,bankno  -- 银行行号
    ,banklv  -- 行级别
    ,bktpid  -- 行分类id
    ,jjdl  -- 国民经济类型
    ,start_dt  -- 开始时间
    ,end_dt  -- 结束时间
    ,id_mark  -- 增删标志
    ,etl_dt  -- ETL处理日期
    ,etl_timestamp  -- ETL处理时间戳
)
select
    replace(replace(t1.custno,chr(13),''),chr(10),'')  -- CIF客户号
    ,replace(replace(t1.lncdpw,chr(13),''),chr(10),'')  -- 贷款卡密码
    ,replace(replace(t1.lncdtg,chr(13),''),chr(10),'')  -- 贷款卡状态
    ,replace(replace(t1.lncddt,chr(13),''),chr(10),'')  -- 贷款卡年审日期
    ,replace(replace(t1.lncdst,chr(13),''),chr(10),'')  -- 贷款卡年审结果
    ,replace(replace(t1.lcditg,chr(13),''),chr(10),'')  -- 贷款卡吊销标志
    ,replace(replace(t1.lcdidt,chr(13),''),chr(10),'')  -- 贷款卡吊销日期
    ,replace(replace(t1.lcdrdt,chr(13),''),chr(10),'')  -- 贷款卡恢复日期
    ,replace(replace(t1.upcrna,chr(13),''),chr(10),'')  -- 主管单位名称
    ,replace(replace(t1.uprgcy,chr(13),''),chr(10),'')  -- 主管单位注册币种
    ,t1.uprgam  -- 主管单位注册金额
    ,replace(replace(t1.upcrps,chr(13),''),chr(10),'')  -- 主管单位法定代表人
    ,replace(replace(t1.upidtp,chr(13),''),chr(10),'')  -- 主管单位法定代表人证件类别
    ,replace(replace(t1.upidno,chr(13),''),chr(10),'')  -- 主管单位法定代表人证件号
    ,replace(replace(t1.upopno,chr(13),''),chr(10),'')  -- 主管单位基本户开户许可证号
    ,replace(replace(t1.upcpcd,chr(13),''),chr(10),'')  -- 主管单位组织机构代码
    ,replace(replace(t1.upcped,chr(13),''),chr(10),'')  -- 主管单位组织机构代码有效期
    ,replace(replace(t1.retxtg,chr(13),''),chr(10),'')  -- 是否办理税务登记证
    ,replace(replace(t1.txdpid,chr(13),''),chr(10),'')  -- 税务机关证明
    ,replace(replace(t1.iscuim,chr(13),''),chr(10),'')  -- 是否国家重点企业
    ,replace(replace(t1.ishtch,chr(13),''),chr(10),'')  -- 是否高新技术企业
    ,t1.stckam  -- 拥有我行股份数
    ,replace(replace(t1.isgrup,chr(13),''),chr(10),'')  -- 是否集团公司
    ,replace(replace(t1.gropid,chr(13),''),chr(10),'')  -- 集团客户id
    ,replace(replace(t1.isgrmo,chr(13),''),chr(10),'')  -- 是否占用集团客户额度
    ,replace(replace(t1.ctylev,chr(13),''),chr(10),'')  -- 行业类型(国标)
    ,replace(replace(t1.waylv5,chr(13),''),chr(10),'')  -- 行业类型(五级分类)
    ,replace(replace(t1.etpcht,chr(13),''),chr(10),'')  -- 行业类型(信用评级)
    ,replace(replace(t1.cuslv3,chr(13),''),chr(10),'')  -- 事业法人规模或级别
    ,replace(replace(t1.custp3,chr(13),''),chr(10),'')  -- 事业法人客户类型
    ,replace(replace(t1.lmtway,chr(13),''),chr(10),'')  -- 限制或鼓励行业
    ,replace(replace(t1.rpmltp,chr(13),''),chr(10),'')  -- 财务报表类型
    ,t1.retinm  -- 离退休人数
    ,t1.unvrnm  -- 大专以上人数
    ,replace(replace(t1.isdrec,chr(13),''),chr(10),'')  -- 有无董事会
    ,replace(replace(t1.provce,chr(13),''),chr(10),'')  -- 所在省市
    ,replace(replace(t1.inoutp,chr(13),''),chr(10),'')  -- 收支方式
    ,replace(replace(t1.worang,chr(13),''),chr(10),'')  -- 职能范围
    ,replace(replace(t1.supeor,chr(13),''),chr(10),'')  -- 上级主管部门
    ,t1.buldmy  -- 开办资金
    ,replace(replace(t1.budgtp,chr(13),''),chr(10),'')  -- 预算形式
    ,replace(replace(t1.orgown,chr(13),''),chr(10),'')  -- 机构隶属
    ,replace(replace(t1.cdradt,chr(13),''),chr(10),'')  -- 与我行首次建立信贷关系日期
    ,replace(replace(t1.prfd01,chr(13),''),chr(10),'')  -- 预留字段
    ,replace(replace(t1.prfd02,chr(13),''),chr(10),'')  -- 预留字段2(组织机构类别细分)
    ,replace(replace(t1.prfd03,chr(13),''),chr(10),'')  -- 预留字段3(机构状态)
    ,t1.prfd04  -- 预留字段
    ,t1.prfd05  -- 预留字段
    ,t1.salmon  -- 销售额
    ,replace(replace(t1.sizehy,chr(13),''),chr(10),'')  -- 企业规模行业
    ,replace(replace(t1.isbank,chr(13),''),chr(10),'')  -- 是否是银监小企业
    ,replace(replace(t1.banksz,chr(13),''),chr(10),'')  -- 银监小企业规模
    ,replace(replace(t1.xwqyid,chr(13),''),chr(10),'')  -- 未知字段1（继承老cif）
    ,replace(replace(t1.jjzzxs,chr(13),''),chr(10),'')  -- 经济组织形式
    ,replace(replace(t1.jjbmlx,chr(13),''),chr(10),'')  -- 国民经济部门类型
    ,replace(replace(t1.caccno,chr(13),''),chr(10),'')  -- 未知字段2（继承老cif）
    ,replace(replace(t1.econtp,chr(13),''),chr(10),'')  -- 经济类型
    ,replace(replace(t1.teleno,chr(13),''),chr(10),'')  -- 联系电话(征信)
    ,replace(replace(t1.vocamx,chr(13),''),chr(10),'')  -- 行业代码明细(征信)
    ,replace(replace(t1.psrntg,chr(13),''),chr(10),'')  -- 居民标示
    ,replace(replace(t1.lwctna,chr(13),''),chr(10),'')  -- 法人代表
    ,replace(replace(t1.lwidno,chr(13),''),chr(10),'')  -- 法人代表证件号码
    ,replace(replace(t1.cptnnm,chr(13),''),chr(10),'')  -- 法人代表证明书编号
    ,replace(replace(t1.vocatp,chr(13),''),chr(10),'')  -- 所属行业
    ,replace(replace(t1.rgstad,chr(13),''),chr(10),'')  -- 地区代码
    ,replace(replace(t1.regidt,chr(13),''),chr(10),'')  -- 注册日期
    ,replace(replace(t1.regiad,chr(13),''),chr(10),'')  -- 注册地址
    ,replace(replace(t1.operar,chr(13),''),chr(10),'')  -- 经营场地面积
    ,replace(replace(t1.custlv,chr(13),''),chr(10),'')  -- 客户级别
    ,replace(replace(t1.statlv,chr(13),''),chr(10),'')  -- 当前评级状态
    ,replace(replace(t1.jonttg,chr(13),''),chr(10),'')  -- 联名客户标志
    ,replace(replace(t1.doubtp,chr(13),''),chr(10),'')  -- 疑似客户类型
    ,t1.tttrib  -- 综合贡献度
    ,t1.ttrema  -- 客户总积分
    ,replace(replace(t1.risklv,chr(13),''),chr(10),'')  -- 风险等级
    ,replace(replace(t1.datatp,chr(13),''),chr(10),'')  -- 数据类型
    ,replace(replace(t1.roletp,chr(13),''),chr(10),'')  -- 参与者类别
    ,replace(replace(t1.isincu,chr(13),''),chr(10),'')  -- 是否系统内客户
    ,replace(replace(t1.iscred,chr(13),''),chr(10),'')  -- 是否授信客户
    ,replace(replace(t1.credid,chr(13),''),chr(10),'')  -- 信用评级ID
    ,t1.credln  -- 授信额度
    ,t1.last_updated_stamp  -- 最后更新时间
    ,t1.last_updated_tx_stamp  -- 最后更新事务时间
    ,t1.created_stamp  -- 创建时间
    ,t1.created_tx_stamp  -- 创建事务时间
    ,replace(replace(t1.bankno,chr(13),''),chr(10),'')  -- 银行行号
    ,replace(replace(t1.banklv,chr(13),''),chr(10),'')  -- 行级别
    ,replace(replace(t1.bktpid,chr(13),''),chr(10),'')  -- 行分类id
    ,replace(replace(t1.jjdl,chr(13),''),chr(10),'')  -- 国民经济类型
    ,t1.start_dt  -- 开始时间
    ,t1.end_dt  -- 结束时间
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt  -- ETL处理日期
    ,t1.etl_timestamp  -- ETL处理时间戳
from ${iol_schema}.eifs_customer_supplement_info_pub t1    --客户补录信息(对公)
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_eifs_customer_supplement_info_pub',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);