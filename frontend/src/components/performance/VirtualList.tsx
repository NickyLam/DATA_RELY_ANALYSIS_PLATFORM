/**
 * 虚拟列表组件
 * 用于渲染大量数据时只渲染可视区域内的元素，提升性能
 */

import React, { useRef, useState, useEffect, useCallback, useMemo } from 'react';

interface VirtualListProps<T> {
  items: T[];
  itemHeight: number;
  containerHeight: number;
  renderItem: (item: T, index: number) => React.ReactNode;
  overscan?: number;
  onScroll?: (scrollTop: number) => void;
  className?: string;
}

function VirtualList<T>({
  items,
  itemHeight,
  containerHeight,
  renderItem,
  overscan = 3,
  onScroll,
  className = '',
}: VirtualListProps<T>) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [scrollTop, setScrollTop] = useState(0);

  // 计算可视区域内的元素范围
  const visibleRange = useMemo(() => {
    const startIndex = Math.max(0, Math.floor(scrollTop / itemHeight) - overscan);
    const endIndex = Math.min(
      items.length - 1,
      Math.ceil((scrollTop + containerHeight) / itemHeight) + overscan
    );
    return { startIndex, endIndex };
  }, [scrollTop, itemHeight, containerHeight, items.length, overscan]);

  // 计算总高度
  const totalHeight = items.length * itemHeight;

  // 计算偏移量
  const offsetY = visibleRange.startIndex * itemHeight;

  // 处理滚动事件
  const handleScroll = useCallback((e: React.UIEvent<HTMLDivElement>) => {
    const target = e.currentTarget;
    const newScrollTop = target.scrollTop;
    setScrollTop(newScrollTop);
    onScroll?.(newScrollTop);
  }, [onScroll]);

  // 渲染可视区域内的元素
  const visibleItems = useMemo(() => {
    const result: React.ReactNode[] = [];
    for (let i = visibleRange.startIndex; i <= visibleRange.endIndex; i++) {
      const item = items[i];
      if (item) {
        result.push(
          <div
            key={i}
            style={{
              position: 'absolute',
              top: i * itemHeight,
              left: 0,
              width: '100%',
              height: itemHeight,
              boxSizing: 'border-box',
            }}
          >
            {renderItem(item, i)}
          </div>
        );
      }
    }
    return result;
  }, [items, visibleRange, renderItem, itemHeight]);

  return (
    <div
      ref={containerRef}
      className={className}
      style={{
        height: containerHeight,
        overflow: 'auto',
        position: 'relative',
      }}
      onScroll={handleScroll}
    >
      <div
        style={{
          height: totalHeight,
          position: 'relative',
        }}
      >
        <div
          style={{
            position: 'absolute',
            top: offsetY,
            left: 0,
            width: '100%',
          }}
        >
          {visibleItems}
        </div>
      </div>
    </div>
  );
}

// 带懒加载的虚拟列表
interface LazyVirtualListProps<T> extends VirtualListProps<T> {
  hasMore?: boolean;
  loadMore?: () => Promise<void>;
  loadingMore?: boolean;
  threshold?: number;
}

export function LazyVirtualList<T>({
  items,
  itemHeight,
  containerHeight,
  renderItem,
  overscan = 3,
  onScroll,
  hasMore = false,
  loadMore,
  loadingMore = false,
  threshold = 100,
  className = '',
}: LazyVirtualListProps<T>) {
  const [internalLoading, setInternalLoading] = useState(false);
  const loadingRef = useRef(false);

  // 检查是否需要加载更多
  const checkLoadMore = useCallback(
    async (scrollTop: number) => {
      if (!hasMore || loadingRef.current || internalLoading || loadingMore) {
        return;
      }

      const scrollBottom = scrollTop + containerHeight;
      const totalHeight = items.length * itemHeight;
      const distanceToBottom = totalHeight - scrollBottom;

      if (distanceToBottom < threshold) {
        loadingRef.current = true;
        setInternalLoading(true);

        try {
          await loadMore?.();
        } finally {
          loadingRef.current = false;
          setInternalLoading(false);
        }
      }
    },
    [hasMore, loadMore, items.length, itemHeight, containerHeight, threshold, internalLoading, loadingMore]
  );

  // 处理滚动事件
  const handleScroll = useCallback(
    (e: React.UIEvent<HTMLDivElement>) => {
      const target = e.currentTarget;
      const newScrollTop = target.scrollTop;
      onScroll?.(newScrollTop);
      checkLoadMore(newScrollTop);
    },
    [onScroll, checkLoadMore]
  );

  const isLoading = internalLoading || loadingMore;

  return (
    <div
      style={{
        height: containerHeight,
        overflow: 'auto',
        position: 'relative',
      }}
      className={className}
      onScroll={handleScroll}
    >
      <VirtualList
        items={items}
        itemHeight={itemHeight}
        containerHeight={containerHeight - (isLoading ? 40 : 0)}
        renderItem={renderItem}
        overscan={overscan}
      />
      {isLoading && (
        <div
          style={{
            height: 40,
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            borderTop: '1px solid #e8e8e8',
          }}
        >
          <span>加载中...</span>
        </div>
      )}
    </div>
  );
}

export default VirtualList;