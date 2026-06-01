/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_mpcs_a60cfidcheck
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
alter table ${idl_schema}.aml_mpcs_a60cfidcheck drop partition p_${last_date};
alter table ${idl_schema}.aml_mpcs_a60cfidcheck drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_mpcs_a60cfidcheck add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_mpcs_a60cfidcheck partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,trannbr  -- 交易流水号
    ,trandate  -- 交易日期
    ,trantime  -- 交易时间
    ,trancode  -- 交易码
    ,linkid  -- 链路ID
    ,bnakcode  -- 银行代码
    ,identype  -- 证件类型
    ,idennbr  -- 证件号码
    ,nationality  -- 国家代码
    ,cltname  -- 证件姓名
    ,issueoffice  -- 签发机构
    ,photoname  -- 相片文件名
    ,chkresult  -- 验证结果
    ,status  -- S：验证成功T：验证失败W：初始状态
    ,srcseqno  -- 报文流水号
    ,srcsysid  -- 系统ID
    ,tlrno  -- 交易代码
    ,brcno  -- 机构号
    ,trndt  -- 日期
    ,chkrtp  -- 
    ,hostnbr  -- 
    ,hostdt  -- 
    ,mutrcd  -- 
    ,trnname  -- 业务交易名称
    ,tmip  -- 客户IP地址
    ,tmmac  -- 客户mac地址
    ,mobile  -- 客户手机号码
    ,tmtype  -- 客户终端
    ,formername  -- 曾用名
    ,gender  -- 性别  性别-GB/T 2261
    ,birthday  -- 出生日期
    ,birthplace  -- 出生地   出生地- GB/T 2260
    ,nativeplace  -- 籍贯  籍贯- GB/T 2260文化程度- GB/T 4658
    ,edulevel  -- 文化程度
    ,marriage  -- 婚姻状况  婚姻状况- GB/T 4766
    ,job  -- 职业
    ,engageaddr  -- 服务处所
    ,address  -- 住址
    ,checkchnl  -- 核查通道0-人行1-国证通2-本地
    ,recordstat  -- 记录状态0-无效1-有效
    ,checkdept  -- 核查部门1-互联网银行事业部2-个人银行部3-公司银行部4-零售信贷部5-金融市场部6-授信审批部7-微贷产品事业部8-交易银行部9-同业银行部
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.trannbr,chr(13),''),chr(10),'')  -- 交易流水号
    ,t1.trandate  -- 交易日期
    ,t1.trantime  -- 交易时间
    ,replace(replace(t1.trancode,chr(13),''),chr(10),'')  -- 交易码
    ,t1.linkid  -- 链路ID
    ,replace(replace(t1.bnakcode,chr(13),''),chr(10),'')  -- 银行代码
    ,replace(replace(t1.identype,chr(13),''),chr(10),'')  -- 证件类型
    ,replace(replace(t1.idennbr,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.nationality,chr(13),''),chr(10),'')  -- 国家代码
    ,replace(replace(t1.cltname,chr(13),''),chr(10),'')  -- 证件姓名
    ,replace(replace(t1.issueoffice,chr(13),''),chr(10),'')  -- 签发机构
    ,replace(replace(t1.photoname,chr(13),''),chr(10),'')  -- 相片文件名
    ,replace(replace(t1.chkresult,chr(13),''),chr(10),'')  -- 验证结果
    ,replace(replace(t1.status,chr(13),''),chr(10),'')  -- S：验证成功T：验证失败W：初始状态
    ,replace(replace(t1.srcseqno,chr(13),''),chr(10),'')  -- 报文流水号
    ,replace(replace(t1.srcsysid,chr(13),''),chr(10),'')  -- 系统ID
    ,replace(replace(t1.tlrno,chr(13),''),chr(10),'')  -- 交易代码
    ,replace(replace(t1.brcno,chr(13),''),chr(10),'')  -- 机构号
    ,replace(replace(t1.trndt,chr(13),''),chr(10),'')  -- 日期
    ,replace(replace(t1.chkrtp,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.hostnbr,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.hostdt,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mutrcd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.trnname,chr(13),''),chr(10),'')  -- 业务交易名称
    ,replace(replace(t1.tmip,chr(13),''),chr(10),'')  -- 客户IP地址
    ,replace(replace(t1.tmmac,chr(13),''),chr(10),'')  -- 客户mac地址
    ,replace(replace(t1.mobile,chr(13),''),chr(10),'')  -- 客户手机号码
    ,replace(replace(t1.tmtype,chr(13),''),chr(10),'')  -- 客户终端
    ,replace(replace(t1.formername,chr(13),''),chr(10),'')  -- 曾用名
    ,replace(replace(t1.gender,chr(13),''),chr(10),'')  -- 性别  性别-GB/T 2261
    ,replace(replace(t1.birthday,chr(13),''),chr(10),'')  -- 出生日期
    ,replace(replace(t1.birthplace,chr(13),''),chr(10),'')  -- 出生地   出生地- GB/T 2260
    ,replace(replace(t1.nativeplace,chr(13),''),chr(10),'')  -- 籍贯  籍贯- GB/T 2260文化程度- GB/T 4658
    ,replace(replace(t1.edulevel,chr(13),''),chr(10),'')  -- 文化程度
    ,replace(replace(t1.marriage,chr(13),''),chr(10),'')  -- 婚姻状况  婚姻状况- GB/T 4766
    ,replace(replace(t1.job,chr(13),''),chr(10),'')  -- 职业
    ,replace(replace(t1.engageaddr,chr(13),''),chr(10),'')  -- 服务处所
    ,replace(replace(t1.address,chr(13),''),chr(10),'')  -- 住址
    ,replace(replace(t1.checkchnl,chr(13),''),chr(10),'')  -- 核查通道0-人行1-国证通2-本地
    ,replace(replace(t1.recordstat,chr(13),''),chr(10),'')  -- 记录状态0-无效1-有效
    ,replace(replace(t1.checkdept,chr(13),''),chr(10),'')  -- 核查部门1-互联网银行事业部2-个人银行部3-公司银行部4-零售信贷部5-金融市场部6-授信审批部7-微贷产品事业部8-交易银行部9-同业银行部
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcs_a60cfidcheck t1    --联网核查流水表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_mpcs_a60cfidcheck',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);