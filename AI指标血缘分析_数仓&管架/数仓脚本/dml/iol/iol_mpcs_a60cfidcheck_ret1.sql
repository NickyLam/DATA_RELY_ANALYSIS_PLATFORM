/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a60cfidcheck
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

declare
     v_flag   number(10) :=0;
          
begin
	for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt 
	             from user_tab_partitions 
	            where table_name = upper('mpcs_a60cfidcheck_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('mpcs_a60cfidcheck')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table mpcs_a60cfidcheck drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table mpcs_a60cfidcheck add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';
end loop;
end;
/
insert /*+ append */ into ${iol_schema}.mpcs_a60cfidcheck(
    trannbr -- 交易流水号
    ,trandate -- 交易日期
    ,trantime -- 交易时间
    ,trancode -- 交易码
    ,linkid -- 链路id
    ,bnakcode -- 银行代码
    ,identype -- 证件类型
    ,idennbr -- 证件号码
    ,nationality -- 国家代码
    ,cltname -- 证件姓名
    ,issueoffice -- 签发机构
    ,photoname -- 相片文件名
    ,chkresult -- 验证结果
    ,status -- s：验证成功t：验证失败w：初始状态
    ,srcseqno -- 报文流水号
    ,srcsysid -- 系统id
    ,tlrno -- 交易代码
    ,brcno -- 机构号
    ,trndt -- 日期
    ,chkrtp -- 
    ,hostnbr -- 
    ,hostdt -- 
    ,mutrcd -- 
    ,trnname -- 业务交易名称
    ,tmip -- 客户ip地址
    ,tmmac -- 客户mac地址
    ,mobile -- 客户手机号码
    ,tmtype -- 客户终端
    ,formername -- 曾用名
    ,gender -- 性别  性别-gb/t 2261
    ,birthday -- 出生日期
    ,birthplace -- 出生地   出生地- gb/t 2260
    ,nativeplace -- 籍贯  籍贯- gb/t 2260文化程度- gb/t 4658
    ,edulevel -- 文化程度
    ,marriage -- 婚姻状况  婚姻状况- gb/t 4766
    ,job -- 职业
    ,engageaddr -- 服务处所
    ,address -- 住址
    ,checkchnl -- 核查通道0-人行1-国证通2-本地
    ,recordstat -- 记录状态0-无效1-有效
    ,checkdept -- 核查部门1-互联网银行事业部2-个人银行部3-公司银行部4-零售信贷部5-金融市场部6-授信审批部7-微贷产品事业部8-交易银行部9-同业银行部
    ,transeqno -- 交易流水号
    ,acctno -- 银行账号
    ,chkrspmsg -- 核查返回信息
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    trannbr -- 交易流水号
    ,trandate -- 交易日期
    ,trantime -- 交易时间
    ,trancode -- 交易码
    ,linkid -- 链路id
    ,bnakcode -- 银行代码
    ,identype -- 证件类型
    ,idennbr -- 证件号码
    ,nationality -- 国家代码
    ,cltname -- 证件姓名
    ,issueoffice -- 签发机构
    ,photoname -- 相片文件名
    ,chkresult -- 验证结果
    ,status -- s：验证成功t：验证失败w：初始状态
    ,srcseqno -- 报文流水号
    ,srcsysid -- 系统id
    ,tlrno -- 交易代码
    ,brcno -- 机构号
    ,trndt -- 日期
    ,chkrtp -- 
    ,hostnbr -- 
    ,hostdt -- 
    ,mutrcd -- 
    ,trnname -- 业务交易名称
    ,tmip -- 客户ip地址
    ,tmmac -- 客户mac地址
    ,mobile -- 客户手机号码
    ,tmtype -- 客户终端
    ,formername -- 曾用名
    ,gender -- 性别  性别-gb/t 2261
    ,birthday -- 出生日期
    ,birthplace -- 出生地   出生地- gb/t 2260
    ,nativeplace -- 籍贯  籍贯- gb/t 2260文化程度- gb/t 4658
    ,edulevel -- 文化程度
    ,marriage -- 婚姻状况  婚姻状况- gb/t 4766
    ,job -- 职业
    ,engageaddr -- 服务处所
    ,address -- 住址
    ,checkchnl -- 核查通道0-人行1-国证通2-本地
    ,recordstat -- 记录状态0-无效1-有效
    ,checkdept -- 核查部门1-互联网银行事业部2-个人银行部3-公司银行部4-零售信贷部5-金融市场部6-授信审批部7-微贷产品事业部8-交易银行部9-同业银行部
    ,transeqno -- 交易流水号
    ,' ' as acctno -- 银行账号
    ,' ' as chkrspmsg -- 核查返回信息
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from mpcs_a60cfidcheck_bak${batch_date}

commit;
