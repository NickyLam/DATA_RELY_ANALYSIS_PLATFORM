/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_group_info
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
                       FROM icms_group_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_group_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_group_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_group_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.icms_group_info(
            groupid -- 客户编号
            ,businessscope -- 经营范围(文本描述)
            ,mgtorgid -- 主办机构
            ,currentversionseq -- 当前正在使用的家谱版本号
            ,countrycode -- 所在国家(地区)
            ,firstloandate -- 首贷日期
            ,groupmembercount -- 集群成员数量
            ,registerregioncode -- 登记地行政区划代码
            ,creditlevel -- 内部信用评级级别
            ,groupcredittype -- 集团类型
            ,customertype -- 客户类型
            ,newregioncode -- 行政区域（风险预警）
            ,industrytypeproportion -- 第一大主营业务占比
            ,city -- 省直辖市/县
            ,officeaddupdatedate -- 更新办公地址日期
            ,isretiveeconmics -- 是否经济依存
            ,groupname -- 集群名称
            ,familymapstatus -- 家谱版本状态
            ,approveorgid -- 复核机构
            ,isrelatedparty -- 是否我行关联方标志
            ,parentcompanyofficeadd -- 集团客户母公司国内办公地址
            ,industrytypeproportion2 -- 第三大主营业务占比
            ,corpidetitytype -- 征信报送企业身份标识类型
            ,refversionseq -- 当前正在维护的家谱版本号
            ,oldfinancefocus -- 过往财务集中情况
            ,oldheadofficemanage -- 过往总行集中管理情况
            ,industrytype -- 所属行业类型
            ,subjectbusiness -- 主营业务(文本描述)
            ,groupstatus -- 集群状态
            ,groupabbname -- 集团简称
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,groupcustomertype -- 集群客户类型
            ,oldgroupcredittype -- 过往集团类型
            ,industrytypeproportion1 -- 第二大主营业务占比
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,mgtuserid -- 主办客户经理
            ,inputorgid -- 登记单位
            ,inputuserid -- 登记人
            ,oldgroupabbname -- 集群曾用简称
            ,isrelativetrade -- 是否我行关联交易
            ,actualcontrollercounts -- 实际控制人个数
            ,remark -- 备注
            ,updateorgid -- 更新机构
            ,industrytype1 -- 第二大主营业务编号(行业代码)
            ,industrytype2 -- 第三大主营业务编号(行业代码)
            ,inputdate -- 登记日期
            ,financialgroupscope -- 规模(文本描述)
            ,financialgroupposition -- 行业地位(文本描述)
            ,grouptype -- 集群类型
            ,approvedate -- 复核日期
            ,oldgroupname -- 集团曾用名
            ,headofficemanage -- 总行集中管理
            ,approveuserid -- 复核人
            ,investmencounts -- 主要出资人个数
            ,keymembercustomerid -- 集团核心企业
            ,financefocus -- 财务是否集中
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,actualcontroller -- 实际控制人
            ,migtcustomerid -- 转换前客户号
            ,iscontroller -- 是否有实控人
            ,controllercerttype -- 实控人证件类型
            ,controllercertid -- 实控人证件号码
            ,controllernational -- 实控人国别
            ,groupnature -- 集团性质
            ,groupcreditcustomertype -- 集团客户类型
            ,groupstatusone -- 集团是否生效
            ,isflow -- 是否修改成员信息走流程：0否，1是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            groupid -- 客户编号
            ,businessscope -- 经营范围(文本描述)
            ,mgtorgid -- 主办机构
            ,currentversionseq -- 当前正在使用的家谱版本号
            ,countrycode -- 所在国家(地区)
            ,firstloandate -- 首贷日期
            ,groupmembercount -- 集群成员数量
            ,registerregioncode -- 登记地行政区划代码
            ,creditlevel -- 内部信用评级级别
            ,groupcredittype -- 集团类型
            ,customertype -- 客户类型
            ,newregioncode -- 行政区域（风险预警）
            ,industrytypeproportion -- 第一大主营业务占比
            ,city -- 省直辖市/县
            ,officeaddupdatedate -- 更新办公地址日期
            ,isretiveeconmics -- 是否经济依存
            ,groupname -- 集群名称
            ,familymapstatus -- 家谱版本状态
            ,approveorgid -- 复核机构
            ,isrelatedparty -- 是否我行关联方标志
            ,parentcompanyofficeadd -- 集团客户母公司国内办公地址
            ,industrytypeproportion2 -- 第三大主营业务占比
            ,corpidetitytype -- 征信报送企业身份标识类型
            ,refversionseq -- 当前正在维护的家谱版本号
            ,oldfinancefocus -- 过往财务集中情况
            ,oldheadofficemanage -- 过往总行集中管理情况
            ,industrytype -- 所属行业类型
            ,subjectbusiness -- 主营业务(文本描述)
            ,groupstatus -- 集群状态
            ,groupabbname -- 集团简称
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,groupcustomertype -- 集群客户类型
            ,oldgroupcredittype -- 过往集团类型
            ,industrytypeproportion1 -- 第二大主营业务占比
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,mgtuserid -- 主办客户经理
            ,inputorgid -- 登记单位
            ,inputuserid -- 登记人
            ,oldgroupabbname -- 集群曾用简称
            ,isrelativetrade -- 是否我行关联交易
            ,actualcontrollercounts -- 实际控制人个数
            ,remark -- 备注
            ,updateorgid -- 更新机构
            ,industrytype1 -- 第二大主营业务编号(行业代码)
            ,industrytype2 -- 第三大主营业务编号(行业代码)
            ,inputdate -- 登记日期
            ,financialgroupscope -- 规模(文本描述)
            ,financialgroupposition -- 行业地位(文本描述)
            ,grouptype -- 集群类型
            ,approvedate -- 复核日期
            ,oldgroupname -- 集团曾用名
            ,headofficemanage -- 总行集中管理
            ,approveuserid -- 复核人
            ,investmencounts -- 主要出资人个数
            ,keymembercustomerid -- 集团核心企业
            ,financefocus -- 财务是否集中
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,actualcontroller -- 实际控制人
            ,' ' as migtcustomerid -- 转换前客户号
            ,' ' as iscontroller -- 是否有实控人
            ,' ' as controllercerttype -- 实控人证件类型
            ,' ' as controllercertid -- 实控人证件号码
            ,' ' as controllernational -- 实控人国别
            ,' ' as groupnature -- 集团性质
            ,' ' as groupcreditcustomertype -- 集团客户类型
            ,' ' as groupstatusone -- 集团是否生效
            ,' ' as isflow -- 是否修改成员信息走流程：0否，1是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from icms_group_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
