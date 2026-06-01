/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_guaranty_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM icms_guaranty_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_guaranty_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_guaranty_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_guaranty_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.icms_guaranty_info(
            guarantyid -- 押品编号
            ,rwisenoughvalue -- 现时是否足值(风险预警)
            ,ownertype -- 所属人客户类型
            ,contracttype -- 担保方式
            ,evaluatenetvalue -- 评估价值（元）
            ,guarantytype -- 押品类型
            ,floorarea -- 不动产建筑面积(平方米)
            ,rwlocation -- 地址/存放地点(风险预警)
            ,rwbuildbuyprice -- 建购价款(风险预警)
            ,evalorgname -- 评估机构
            ,ownerid -- 权利人客户编号
            ,realestatecode -- 不动产证号
            ,guarantystatus -- 担保状态
            ,updateorgid -- 更新机构
            ,rwpledgerate -- 现时抵质押率(风险预警)
            ,guarantyname -- 押品名称
            ,lettertype -- 保函类型
            ,lettercontry -- 证书开具国别
            ,evaldate -- 估值日期
            ,ypguarantyid -- 押品系统的编号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,letterno -- 保函编号
            ,certid -- 所属人证件号码
            ,confirmvalue -- 我行确认价值
            ,inputuserid -- 登记人
            ,lettersum -- 保函金额
            ,guarantyrightid -- 权证号码
            ,inputdate -- 登记日期
            ,guarantyrighttype -- 权证类型
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,issueorgtype -- 担保机构类型
            ,ownername -- 权属人名称
            ,certtype -- 所属人证件类型
            ,guaranteetype -- 保证担保形式
            ,lettercurrency -- 保函币种
            ,inputorgid -- 登记机构
            ,rwpracticalvalue -- 现时实际价值(风险预警)
            ,guarantylocation -- 抵押物地址
            ,aboutotherid1 -- 母账号
            ,aboutotherid2 -- 
            ,aboutotherid3 -- 
            ,financialyield -- 
            ,collateraltype -- 
            ,stockcode -- 
            ,stockname -- 
            ,shareamount -- 
            ,persharemarketprice -- 
            ,totalvalue -- 
            ,warningline -- 
            ,liquidateline -- 
            ,evalexpiredate -- 
            ,registerno -- 
            ,statuschangetime -- 
            ,isnewshilianassessvalue -- 
            ,newshilianassessvalue -- 
            ,newshilianassessdate -- 
            ,isshilianaccevaluate -- 
            ,isourbankaccevaluate -- 
            ,externalevaluatevalue -- 
            ,externalevaluatedate -- 
            ,externalevaluateexpiredate -- 
            ,remark -- 备注
            ,registcountry -- 保证人注册地所在国家或地区
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,guarcash -- 担保公司保证金金额
            ,isstage -- 是否阶段性担保
            ,insuranceno -- 保证保险保单号码
            ,purpose -- 保证目的
            ,independence -- 保证人担保独立性
            ,isresident -- 是否居民
            ,netassetcurrency -- 净资产币种
            ,orgname -- 开立机构名称（保函）\开证机构名称（信用证）
            ,orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
            ,iscancel -- 是否不可撤销
            ,vouchertype -- 保证人所有制类型
            ,netasset -- 保证人净资产
            ,confirmcurrency -- 担保币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            guarantyid -- 押品编号
            ,rwisenoughvalue -- 现时是否足值(风险预警)
            ,ownertype -- 所属人客户类型
            ,contracttype -- 担保方式
            ,evaluatenetvalue -- 评估价值（元）
            ,guarantytype -- 押品类型
            ,floorarea -- 不动产建筑面积(平方米)
            ,rwlocation -- 地址/存放地点(风险预警)
            ,rwbuildbuyprice -- 建购价款(风险预警)
            ,evalorgname -- 评估机构
            ,ownerid -- 权利人客户编号
            ,realestatecode -- 不动产证号
            ,guarantystatus -- 担保状态
            ,updateorgid -- 更新机构
            ,rwpledgerate -- 现时抵质押率(风险预警)
            ,guarantyname -- 押品名称
            ,lettertype -- 保函类型
            ,lettercontry -- 证书开具国别
            ,evaldate -- 估值日期
            ,ypguarantyid -- 押品系统的编号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,letterno -- 保函编号
            ,certid -- 所属人证件号码
            ,confirmvalue -- 我行确认价值
            ,inputuserid -- 登记人
            ,lettersum -- 保函金额
            ,guarantyrightid -- 权证号码
            ,inputdate -- 登记日期
            ,guarantyrighttype -- 权证类型
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,issueorgtype -- 担保机构类型
            ,ownername -- 权属人名称
            ,certtype -- 所属人证件类型
            ,guaranteetype -- 保证担保形式
            ,lettercurrency -- 保函币种
            ,inputorgid -- 登记机构
            ,rwpracticalvalue -- 现时实际价值(风险预警)
            ,guarantylocation -- 抵押物地址
            ,aboutotherid1 -- 母账号
    ,' ' as aboutotherid2 -- 
    ,' ' as aboutotherid3 -- 
    ,0 as financialyield -- 
    ,' ' as collateraltype -- 
    ,' ' as stockcode -- 
    ,' ' as stockname -- 
    ,0 as shareamount -- 
    ,0 as persharemarketprice -- 
    ,0 as totalvalue -- 
    ,0 as warningline -- 
    ,0 as liquidateline -- 
    ,to_date('00010101','yyyymmdd') as evalexpiredate -- 
    ,' ' as registerno -- 
    ,to_date('00010101','yyyymmdd') as statuschangetime -- 
    ,' ' as isnewshilianassessvalue -- 
    ,' ' as newshilianassessvalue -- 
    ,to_date('00010101','yyyymmdd') as newshilianassessdate -- 
    ,' ' as isshilianaccevaluate -- 
    ,' ' as isourbankaccevaluate -- 
    ,0 as externalevaluatevalue -- 
    ,to_date('00010101','yyyymmdd') as externalevaluatedate -- 
    ,to_date('00010101','yyyymmdd') as externalevaluateexpiredate -- 
    ,' ' as remark -- 备注
    ,' ' as registcountry -- 保证人注册地所在国家或地区
    ,' ' as registcountryresult -- 保证人注册地所在国家或地区外部评级结果
    ,' ' as outratingdate -- 保证人外部评级日期
    ,' ' as outratingresult -- 保证人外部评级结果
    ,' ' as inratingdate -- 保证人内部评级日期
    ,' ' as inratingresult -- 保证人内部评级结果
    ,0 as guarcash -- 担保公司保证金金额
    ,' ' as isstage -- 是否阶段性担保
    ,' ' as insuranceno -- 保证保险保单号码
    ,' ' as purpose -- 保证目的
    ,' ' as independence -- 保证人担保独立性
    ,' ' as isresident -- 是否居民
    ,' ' as netassetcurrency -- 净资产币种
    ,' ' as orgname -- 开立机构名称（保函）\开证机构名称（信用证）
    ,' ' as orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
    ,' ' as iscancel -- 是否不可撤销
    ,' ' as vouchertype -- 保证人所有制类型
    ,0 as netasset -- 保证人净资产
    ,' ' as confirmcurrency -- 担保币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from icms_guaranty_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
